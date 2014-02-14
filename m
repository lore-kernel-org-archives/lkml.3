Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaBNM1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:27:15 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62266 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaBNM1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:27:13 -0500
MIME-Version: 1.0
In-Reply-To: <1392376711-11290-2-git-send-email-tomi.valkeinen@ti.com>
References: <1392376711-11290-1-git-send-email-tomi.valkeinen@ti.com>
	<1392376711-11290-2-git-send-email-tomi.valkeinen@ti.com>
Date: Fri, 14 Feb 2014 13:27:13 +0100
X-Google-Sender-Auth: eqd9FhswrGJEFgCCK5LnuMVQgRY
Message-ID: <CAMuHMdWWOUVe-16VBZ098-OfB21X9Wz1wO8gmSUy4PsFvQoX1A@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] fbdev: move fbdev core files to separate directory
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Thanks for doing this!

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

On Fri, Feb 14, 2014 at 12:18 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> --- a/drivers/video/fbdev/fbmon.c
> +++ b/drivers/video/fbdev/core/fbmon.c
> @@ -37,7 +37,7 @@
>  #include <asm/prom.h>
>  #include <asm/>
>  /*
>   * EDID parserpci-bridge.h>
>  #endif
> -#include "edid.h"
> +#include "../edid.h"

This looks a bit asymmetrical ...

> --- a/drivers/video/fbdev/wmt_ge_rops.c
> +++ b/drivers/video/fbdev/wmt_ge_rops.c
> @@ -18,7 +18,7 @@
>  #include <linux/module.h>
>  #include <linux/fb.h>
>  #include <linux/platform_device.h>
> -#include "fb_draw.h"
> +#include "core/fb_draw.h"

... to this.

Perhaps (the content of) edid.h belongs in include/video/edid.h?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
