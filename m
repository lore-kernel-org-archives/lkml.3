Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaGJTaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:30:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:50676 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaGJTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:30:11 -0400
Date: Thu, 10 Jul 2014 21:30:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <rdunlap@infradead.org>
cc: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: Docbook: Fix files location change of
 kernel/[hr]timer.c in device-drivers.tmpl
In-Reply-To: <53BEE172.4050208@infradead.org>
Message-ID: <alpine.DEB.2.10.1407102129400.4357@nanos>
References: <1405017830-31194-1-git-send-email-standby24x7@gmail.com> <53BEE172.4050208@infradead.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Randy Dunlap wrote:

> On 07/10/2014 11:43 AM, Masanari Iida wrote:
> > make xmldocs failed because of file location change
> > from kernel/[hr]timer.c to kernel/time/[hr]timer.c.
> 
> When does this change happen?  I don't see it in Linus's current git tree.

It's in my timer tree. I forgot about that. Will pick it up.
 
> Thanks.
> 
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> > ---
> >  Documentation/DocBook/device-drivers.tmpl | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> > index dd3f278..f213058 100644
> > --- a/Documentation/DocBook/device-drivers.tmpl
> > +++ b/Documentation/DocBook/device-drivers.tmpl
> > @@ -54,7 +54,7 @@
> >  !Ikernel/sched/cpupri.c
> >  !Ikernel/sched/fair.c
> >  !Iinclude/linux/completion.h
> > -!Ekernel/timer.c
> > +!Ekernel/time/timer.c
> >       </sect1>
> >       <sect1><title>Wait queues and Wake events</title>
> >  !Iinclude/linux/wait.h
> > @@ -63,7 +63,7 @@
> >       <sect1><title>High-resolution timers</title>
> >  !Iinclude/linux/ktime.h
> >  !Iinclude/linux/hrtimer.h
> > -!Ekernel/hrtimer.c
> > +!Ekernel/time/hrtimer.c
> >       </sect1>
> >       <sect1><title>Workqueues and Kevents</title>
> >  !Ekernel/workqueue.c
> > 
> 
> 
> -- 
> ~Randy
> 
