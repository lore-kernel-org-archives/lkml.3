Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab3L2JaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 04:30:06 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47649 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3L2JaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 04:30:02 -0500
MIME-Version: 1.0
In-Reply-To: <201312290011.26801.gheskett@wdtv.com>
References: <201312282141.40725.gheskett@wdtv.com>
	<20131229043547.GJ19878@titan.lakedaemon.net>
	<201312290011.26801.gheskett@wdtv.com>
Date: Sun, 29 Dec 2013 10:30:01 +0100
X-Google-Sender-Auth: tDhCtc68zaUz9YXgfTBI3cmpCGE
Message-ID: <CAMuHMdXv0toxKHOfWkb2Vj-mxOBi-F7VdryTC=J6UiEi5VNEMQ@mail.gmail.com>
Subject: Re: Git puzzle
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gene,

On Sun, Dec 29, 2013 at 6:11 AM, Gene Heskett <gheskett@wdtv.com> wrote:
> Yes, I think I can nail it now.  One final clarification, do I use a
> .config geared more to my machine, or am I supposed to do a "make
> allmodconfig?"
>
> I haven't done this in a while and I'm still going thru the xconfig,
> stripping out modules for hardware I don't have, but if I just transfer the
> old ones in, they should work but will be building about 1400 modules
> extra.

If you're using ccache ('make CROSS_COMPILE="ccache "'), it may be
much faster to just build everything, than to try to find a config subset that
contains everything you need. And the further in the bisection process, the
less that needs to be recompiled.

Good luck!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
