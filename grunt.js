/*
 * Grunt file to build the QuickUI Catalog.
 *
 * This has to encompass two separate build systems: one for new controls built
 * with CoffeeScript + LESS, and one for older controls built with QuickUI
 * Markup (http://github.com/JanMiksovsky/quickui-markup). Both types of
 * controls are built separate, and the output of both are then combined.
 *
 * This also builds the unit tests.
 */

module.exports = function(grunt) {

    grunt.loadTasks( "../quickui/grunt" );
    grunt.loadNpmTasks( "grunt-less" );
    grunt.loadTasks( "grunt" );

    var sortDependencies = require( "./grunt/sortDependencies.js" );

    // Project configuration.
    grunt.initConfig({
        coffee: {
            controls: {
                src: sortDependencies.sortClassFiles( "coffee/*.coffee" ),
                dest: "coffee/coffee.js",
                options: { bare: false }
            },
            test: {
                src: [ "test/*.coffee" ],
                dest: "test/unittests.js",
                options: { bare: false }
            }
        },
        less: {
            controls: {
                src: sortDependencies.sortClassFiles( "coffee/*.less" ),
                dest: "coffee/coffee.css"
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
        quidoc: {
            controls: {
                src: [ "coffee", "markup" ],
                dest: "docs/controlDocumentation.js"
            }
        }
    });

    // Default task.
    grunt.registerTask( "default", "coffee less qb concat" );
    
};
