/*
 * Grunt file to build the QuickUI Catalog.
 *
 * This has to encompass two separate build systems: one for new controls built
 * with CoffeeScript + LESS, and one for older controls built with QuickUI
 * Markup (http://github.com/JanMiksovsky/quickui-markup). Both types of
 * controls are built separate, and the output of both are then combined.
 *
 * This also builds the unit tests.
 * 
 */

module.exports = function(grunt) {

    grunt.loadNpmTasks( "grunt-contrib-coffee" );
    grunt.loadNpmTasks( "grunt-contrib-less" );
    grunt.loadNpmTasks( "quickui-markup" );

    var sortDependencies = require( "sort-dependencies" );

    // Project configuration.
    grunt.initConfig({
        coffee: {
            controls: {
                files: {
                    "coffee/coffee.js": sortDependencies.sortFiles( "coffee/*.coffee" )
                }
            },
            test: {
                files: {
                    "test/unittests.js": "test/*.coffee"
                }
            },
            // samples: {
            //     src: [ "samples/*.coffee" ],
            //     dest: ""
            // },
            /* Build the quidoc Grunt task itself. */
            tools: {
                files: {
                    "grunt/quidoc.js": "grunt/quidoc.coffee"
                }
            }
        },
        less: {
            controls: {
                files: {
                    "coffee/coffee.css": sortDependencies.sortFiles( "coffee/*.less" )
                }
            }
        },
        qb: {
            controls: {
                path: "markup"
            },
            docs: {
                path: "docs"
            }
        },
        concat: {
            js: {
                src: [
                    "markup/markup.js",
                    "coffee/coffee.js"
                ],
                dest: "quickui.catalog.js"
            },
            css: {
                src: [
                    "markup/markup.css",
                    "coffee/coffee.css"
                ],
                dest: "quickui.catalog.css"
            }
        },
        /* quidoc CoffeeScript tool needs to be built via coffee task */
        quidoc: {
            controls: {
                src: [ "coffee", "markup" ],
                dest: "docs/controlDocumentation.js"
            }
        }
    });

    // Default task.
    grunt.registerTask( "default", "coffee less qb concat" );

    grunt.registerTask( "all", "default quidoc" );
    
};
