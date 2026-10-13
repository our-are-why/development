# .apple-container

Tooling for running projects in Apple `container` dev containers. A project
runs in its own container, with code-server and Claude Code, built from a
shared base image.

    image_develop-base/   the shared base image
    template_project/     the starting point for new projects
    scripts/              create projects, clean up

Projects live inside the folder that holds `.apple-container`. That folder
also holds two folders the projects share; create both before starting a
project:

    .coder-config/   code-server's password, and the settings, keybindings
                     and snippets in code-server-user/
    .coder-local/    the containers' ~/.local

Each project keeps its own code-server extensions and editor state in its
`.coder-data` folder.

Run the scripts on the Mac host; they work from other directories too.

## Build

Build the base image first, then a project, then start it:

    .apple-container/image_develop-base/buildImage.sh
    <project>/.environment/scripts/buildContainer.sh [image-name]
    <project>/.environment/scripts/startContainer.sh [code-server-host-port] [image-name]

The image name defaults to the project directory's name, lowercased, and the
code-server port to 8080. Use a different port per project to run several at
once.

Open code-server at `http://localhost:<code-server-host-port>`. Its password
is in `.coder-config/code-server/config.yaml`.

To update the tools in the base image, rebuild it, then rebuild the projects.

## New project

    .apple-container/scripts/createProject.sh path/to/project

The directory must not exist yet and must be inside the folder that holds
`.apple-container`. Its name, lowercased, must be a valid image name (letters
and digits, joined by `.`, `_` or `-`).

## Log in to Claude Code

1. In a code-server terminal, run `claude` and start the login.
2. Open the link it shows in your Mac's browser and sign in. The browser then
   ends on a `http://localhost:...` page that fails to load.
3. Copy that page's URL, open a second code-server terminal, and run:

       relayOAuthCallback_Claude '<url>'

4. Back in the first terminal, Claude Code finishes the login.

The login lasts until the container restarts.

## Clean up

Scripts in `.apple-container/scripts/`:

| Script                       | Removes                                         |
|------------------------------|-------------------------------------------------|
| `pruneContainers_Stopped.sh` | stopped containers                              |
| `pruneArtifacts_Projects.sh` | stopped containers and unused images            |
| `pruneVolumes_Unused.sh`     | volumes no container uses, with their data      |
| `pruneNetworks_Unused.sh`    | networks no container is connected to           |
| `pruneBuilderCache.sh`       | the build cache                                 |
| `pruneBuilder.sh`            | the builder and its build cache                 |
| `nukeAll.sh`                 | containers, machines, images, volumes, networks |

The project scripts leave the builder alone, and the builder scripts leave
your containers and images alone. `nukeAll.sh` is the full reset, running
containers included. `pruneArtifacts_Projects.sh` and `nukeAll.sh` can remove
the base image and project images, so rebuild them before starting a project
again. A project's volumes count as unused while the project isn't running.
