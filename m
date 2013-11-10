Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab3KJIuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 03:50:09 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62328 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3KJIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 03:50:05 -0500
In-Reply-To: <alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com> <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg> <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de> <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com> <alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de>
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
Date: Sun, 10 Nov 2013 21:49:58 +1300
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

> Is there an easy to setup/use emulator around on which I could try to
> dig into that myself?

I believe Geert uses ARAnyM for his tests of m68k kernels on emulators 
- it is reasonably easy to set up and use. I've used it to debug 
problems we had with the SLUB allocator two years ago.

Emulation is for Atari Falcon 040 hardware, things like interrupt 
priorities ought to be reproduced faithfully.

Not that it would hurt to try Geert's last non-booting kernel on true 
hardware - either send the kernel image or a patch to apply to your 
current tree please, Geert.

Regards,

	Michael

