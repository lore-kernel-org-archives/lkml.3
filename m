Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaCEVy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:54:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:46859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaCEVyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:54:55 -0500
Date: Wed, 5 Mar 2014 22:54:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Finn Thain <fthain@telegraphics.com.au>, Greg Ungerer <gerg@uclinux.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: skip futex_atomic_cmpxchg_inatomic() test
In-Reply-To: <CAMuHMdU-5dw9mzJTf-29FAo1NBOnUnqCDv9GPfYRTvuRCS+9Xw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403052254110.18573@ionos.tec.linutronix.de>
References: <alpine.LNX.2.00.1403041740580.17377@nippy.intranet> <CAMuHMdU-5dw9mzJTf-29FAo1NBOnUnqCDv9GPfYRTvuRCS+9Xw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Geert Uytterhoeven wrote:

> On Tue, Mar 4, 2014 at 8:28 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> > The futex_atomic_cmpxchg_inatomic() test in futex_init() causes a fatal
> > exception on 68030 (and presumably 68020 also).
> 
> Thanks!
> 
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> > ---
> >
> > Ingo Molnar has committed Heiko Carstens' patch to the -tip repo:
> 
> You mean Thomas Gleixner? ;-)
> 
> > http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=03b8c7b623c80af264c4c8d6111e5c6289933666
> >
> > I downloaded that patch and tested it along with the patch below, and
> > together these fix the boot crash.
> >
> > What's the best way to merge this? Perhaps it should be sent on to the
> > -tip maintainers?
> 
> Yes, please.

Just post it to LKML and cc me please.

Thanks,

	tglx
	
