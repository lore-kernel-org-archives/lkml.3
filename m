Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3KKTnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:43:14 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:57177 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab3KKTnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:43:05 -0500
X-Auth-Info: oy8rytWwhKvAxItiWvzZbE7gPJTuLOcF+dMOzaHDags=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
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
	<CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com>
	<alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de>
X-Yow: My LESLIE GORE record is BROKEN..
Date: Mon, 11 Nov 2013 20:42:59 +0100
In-Reply-To: <alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de>
	(Thomas Gleixner's message of "Mon, 11 Nov 2013 15:11:10 +0100 (CET)")
Message-ID: <87r4amencs.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> And I can see ever repeating
>
>   IRQ 13 flags 0x400 regs->sr 0x400
>
> with a few
>
>   IRQ 15 flags 0x400 regs->sr 0x400
>
> sprinkeled in.
>
> Not what you would expect, right?

If you configured for ATARI only, then ALLOWINT filters out the I1 bit,
which makes irq level 4 and level 6 look the same (all MFP interrupts
are at level 6).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
