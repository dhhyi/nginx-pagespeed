Pagespeed container using NGINX
===

> Mod_pagespeed is an open-source Apache HTTP Server or Nginx webservers module, which automatically applies chosen filters to pages and associated assets, such as stylesheets, JavaScript, and HTML files, as well as to images and website cache requirements. The largest advantage of this module is that it does not require modifications to existing content or workflow, meaning that all internal optimizations and changes to files are made on the server side, presenting modified files directly to the user. Each of 40+ filters corresponds to one of Google’s web performance best practices rules.
> -- [Wikipedia](https://en.wikipedia.org/w/index.php?title=Google_PageSpeed_Tools&oldid=751619122#PageSpeed_Module)


##Usage

This module is build to work as a very minimal and generic image.

You have to link a container to the image or place them on the same network.

Simple run statement:

```console
docker run --link somecontainer:app sheogorath/nginx-pagespeed
```

Run the container in a network and specify the target:

```console
docker run --network app-network -e "NGX_ADDRESS=app" -e NGX_PORT=1234 sheogorath/nginx-pagespeed
```

## Options

We currently use a generic way to generate our configs for mod_pagespeed. But there are some settings to generate the upstream config:

|Name        |Example|Description                                   |
|------------|-------|----------------------------------------------|
|NGX_ADDRESS |`app`  |Name of the upstream container/service        |
|NGX_PORT    |`80`   |Port number of the upstream container/service |

### Configure mod_pagespeed

To configure mod_pagespeed simply add an environment variable prefixed with `NPSC_` and the config name.

Everything becomes upper-cased and to regenerate the Camelcases place a `_` between the words.

As reference check https://modpagespeed.com/

Some examples:

```
EnableFilters               -> NPSC_ENABLE_FILTERS
DisableRewriteOnNoTransform -> NPSC_DISABLE_REWRITE_ON_NO_TRANSFORM
XHeaderValue                -> NPSC_X_HEADER_VALUE
```

### A useful default example

docker run --network app-network -e "NGX_ADDRESS=app" -e NGX_PORT=1234 -e "NPSC_ENABLE_FILTERS=in_place_optimize_for_browser,inline_preview_images,lazyload_images,remove_comments,local_storage_cache,responsive_image,move_css_to_head,move_css_above_scripts,collapse_whitespace,combine_javascript,convert_jpeg_to_webp" -e "NPSC_JS_PRESERVE_UR_Ls=on" sheogorath/nginx-pagespeed

