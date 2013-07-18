Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3GRICc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:02:32 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39845 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3GRIC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:02:28 -0400
MIME-Version: 1.0
In-Reply-To: <51E72752.9020206@zytor.com>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
	<20130716004727.b60b2c96.akpm@linux-foundation.org>
	<20130716005611.e4ccab02.akpm@linux-foundation.org>
	<201307161008.07643.yann.morin.1998@free.fr>
	<20130716180408.GA19863@merkur.ravnborg.org>
	<20130717211649.GA5619@merkur.ravnborg.org>
	<20130717223033.GF3385@free.fr>
	<51E72752.9020206@zytor.com>
Date: Thu, 18 Jul 2013 10:02:27 +0200
X-Google-Sender-Auth: cKLzLhKDzr5A1dB4-CruWLhVI_g
Message-ID: <CAMuHMdVo3rnTtXUZOZavdjJ4uHv4KYPA5g1Py6GTdZD3dPwFzQ@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kyungsik Lee <kyungsik.lee@lge.com>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hyojun.im@lge.com, chan.jeong@lge.com,
        Andy Lee <raphael.andy.lee@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 1:22 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> It is worth noting that one of the things that keep getting brought up
> as something that need this is gcc/binutils support for a specific feature.

Yeah, then those tests would be run only once, at kconfig time. I guess we
still run some of them many times, due to the use of recursive make?

Note that these will end up in your .config --- which is not necesarily a bad
thing --- but it does mean that if e.g. you sent me your .config,
several options
may change when I try to use it.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
