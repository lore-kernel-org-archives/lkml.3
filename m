Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbbAULIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:08:12 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:34533 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbbAULIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <20150121192608.61062b6a@canb.auug.org.au>
References: <20150121192608.61062b6a@canb.auug.org.au>
Date: Wed, 21 Jan 2015 12:08:05 +0100
X-Google-Sender-Auth: RIonN9knMYYkDkgIr_5Hrr7l-G8
Message-ID: <CAMuHMdXuO+tYjSSnxg+B26MbiXiG-1mmFZ+=rx+OsxnnSPbcnA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 21
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Jan 21, 2015 at 9:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Removed trees: (not updated for more that 1 year)
>         configfs
>         cpupowerutils
>         dwmw2
>         embedded
>         ep93xx
>         fbdev
>         firmware
>         fsnotify
>         fw-nohz
>         hwspinlock
>         input-mt
>         ixp4xx
>         kconfig
>         logfs
>         lzo-update
>         md-current
>         msm
>         omfs
>         openrisc
>         oprofile
>         parisc
>         pcmcia
>         signal
>         sysctl
>         uclinux
>         uml
>         uprobes
>         viafb
>         writeback

Have you informed the corresponding maintainers?
Especially architecture-specific trees like openrisc and parisc may still
be (somewhat) active.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
