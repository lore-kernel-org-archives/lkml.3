Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab3KLJSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:18:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:45482 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3KLJSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:18:15 -0500
Date: Tue, 12 Nov 2013 10:18:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Schwab <schwab@linux-m68k.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
In-Reply-To: <87r4amencs.fsf@igel.home>
Message-ID: <alpine.DEB.2.02.1311121016210.30673@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com> <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
 <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de> <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com> <alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de> <ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de>
 <CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com> <alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de> <87r4amencs.fsf@igel.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, Andreas Schwab wrote:

> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > And I can see ever repeating
> >
> >   IRQ 13 flags 0x400 regs->sr 0x400
> >
> > with a few
> >
> >   IRQ 15 flags 0x400 regs->sr 0x400
> >
> > sprinkeled in.
> >
> > Not what you would expect, right?
> 
> If you configured for ATARI only, then ALLOWINT filters out the I1 bit,
> which makes irq level 4 and level 6 look the same (all MFP interrupts
> are at level 6).

Fair enough.



