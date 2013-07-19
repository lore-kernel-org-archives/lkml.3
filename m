Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab3GSNVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:21:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:49682 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab3GSNVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:21:07 -0400
Date: Fri, 19 Jul 2013 15:21:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.10.0 i386 uniprocessor panic
In-Reply-To: <20130718081859.GA23405@pd.tnic>
Message-ID: <alpine.DEB.2.02.1307191519390.4089@ionos.tec.linutronix.de>
References: <20130718061347.17426.qmail@science.horizon.com> <20130718081859.GA23405@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013, Borislav Petkov wrote:
> On Thu, Jul 18, 2013 at 02:13:47AM -0400, George Spelvin wrote:
> > I ressurected an old Athlon XP box for fun, and was stress-testing it
> > with mprime.  (It had been stable before retirement.)  After 34 hours
> > of successful torture test (suggesting a stable memory syatem), I found
> > this on the screen (hand-transcribed, top scrolled off):
> > Call Trace:
> >  [<c102437d>] ? call_timer_fn.isra.37+0x16/0x6d
> >  [<c1024524>] ? run_timer_softirq+0x150/0x165
> >  [<c1020e8b>] ? __do_softirq+0x8b/0x135

Can you please enable debugobjects. That should catch the offender.

Thanks,

	tglx
