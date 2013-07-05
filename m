Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948Ab3GEN0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:26:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:45268 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964908Ab3GEN0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:26:09 -0400
Date: Fri, 5 Jul 2013 15:26:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Artem Savkov <artem.savkov@gmail.com>
cc: David Vrabel <david.vrabel@citrix.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org
Subject: Re: [tip:timers/core] hrtimers: Support resuming with two or more
 CPUs online (but stopped)
In-Reply-To: <20130705104558.GC4033@cpv436-motbuntu>
Message-ID: <alpine.DEB.2.02.1307051520210.32106@ionos.tec.linutronix.de>
References: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com> <tip-7c4c3a0f18ba57ea2a2985034532303d2929902a@git.kernel.org> <20130705093003.GA4033@cpv436-motbuntu> <51D69ACF.9020001@citrix.com> <alpine.DEB.2.02.1307051225060.11637@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1307051229190.32106@ionos.tec.linutronix.de> <20130705104558.GC4033@cpv436-motbuntu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Artem Savkov wrote:
> On Fri, Jul 05, 2013 at 12:36:50PM +0200, Thomas Gleixner wrote:
> > On Fri, 5 Jul 2013, Thomas Gleixner wrote:
> > > On Fri, 5 Jul 2013, David Vrabel wrote:
> > > You failed to CC Artem :(
> > Second thought.
> > Where is that warning? Can't find it in neither in Linus tree nor in tip
> > > > > [ 4363.083800] WARNING: CPU: 0 PID: 3977 at kernel/smp.c:385 smp_call_function_many+0xbd/0x2c0()
> > All I see there is:
> >         WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
> >                      && !oops_in_progress && !early_boot_irqs_disabled);
> 
> It's in linux-next.git, not sure where it was merged from

via akpm.

