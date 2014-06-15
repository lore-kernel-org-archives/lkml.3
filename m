Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaFOI5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 04:57:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45485 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaFOI5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 04:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140614143550.59367463@neptune.home>
References: <539C1C1F.5060904@biereigel.de>
	<20140614143550.59367463@neptune.home>
Date: Sun, 15 Jun 2014 10:57:48 +0200
X-Google-Sender-Auth: UWqCEGKPF9bZOiqo9H6ffeWivDU
Message-ID: <CAMuHMdXMWFXG99iiuk1j=0DaQbWbmcpGxaTfDNX8o+Dz7MH7aw@mail.gmail.com>
Subject: Re: console / fbdev: fbcon support for bits_per_pixel = 1?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Stefan Biereigel <stefan@biereigel.de>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-console@vger.kernel.org, brian <brian.fonfara@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 2:35 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>> Is this behavior intended or are we triggering a bug here (that no one noticed, because
>> who in the world uses monochrome framebuffers these days..). I can't see any comments that
>> monochrome consoles should not work with 1 bit per pixel. See the code below if you spot
>> some errors (ignore some missing error handling and mediocre style for now, please).
>
> fbcon on 1bpp frambuffer worked for me with picoLCD (though I have found no userspace

I'm not aware of 1 bpp frame buffer consoles being broken.

> framebuffer application willing to operate at 1bpp).

Xfbdev does. I revived support for monochrome (and Atari/Amiga-style
bitplanes) last year.

And of course
https://git.kernel.org/cgit/linux/kernel/git/geert/fbtest.git/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
