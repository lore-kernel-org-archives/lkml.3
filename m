Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003Ab3KJJMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 04:12:48 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43415 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3KJJMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 04:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de>
References: <20130917082838.218329307@infradead.org>
	<20130917182350.449685712@linutronix.de>
	<20130917183628.534494408@linutronix.de>
	<CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com>
	<alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de>
	<87txhg3ftx.fsf@igel.home>
	<CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com>
	<alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
	<alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de>
	<CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com>
	<alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de>
	<ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de>
Date: Sun, 10 Nov 2013 10:12:39 +0100
X-Google-Sender-Auth: U9mP-ebo0oeYewO92KvUP-3Bwgk
Message-ID: <CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 9:49 AM, Michael Schmitz
<schmitz@biophys.uni-duesseldorf.de> wrote:
>> Is there an easy to setup/use emulator around on which I could try to
>> dig into that myself?
>
> I believe Geert uses ARAnyM for his tests of m68k kernels on emulators - it
> is reasonably easy to set up and use. I've used it to debug problems we had
> with the SLUB allocator two years ago.

Indeed. ARAnyM is the way to go.

> Not that it would hurt to try Geert's last non-booting kernel on true
> hardware - either send the kernel image or a patch to apply to your current
> tree please, Geert.

Patches sent by private email.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
