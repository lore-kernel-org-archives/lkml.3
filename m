Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3AQGNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 01:13:14 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:51617 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3AQGNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 01:13:13 -0500
MIME-Version: 1.0
In-Reply-To: <1358391258-1771-67-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
	<1358391258-1771-67-git-send-email-keescook@chromium.org>
Date: Thu, 17 Jan 2013 07:13:12 +0100
X-Google-Sender-Auth: UHua7wi6qI3dtnWYj16qnfedTpI
Message-ID: <CAMuHMdUfMUYjFEft=UDsdnvD2ASQavCGWBwj6H+XUSNJ5UiuZQ@mail.gmail.com>
Subject: Re: [PATCH 66/86] drivers/video/console: remove depends on CONFIG_EXPERIMENTAL
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>, Paul Bolle <pebolle@tiscali.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 3:53 AM, Kees Cook <keescook@chromium.org> wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

>  config MDA_CONSOLE
>         depends on !M68K && !PARISC && ISA
> -       tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
> +       tristate "MDA text console (dual-headed)"

This is not a "depends on" line.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
