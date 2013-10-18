Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3JRMuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:50:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab3JRMuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:50:24 -0400
Date: Fri, 18 Oct 2013 14:50:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Xie XiuQi <xiexiuqi@huawei.com>, Thomas Gleixner <tglx@linutronix.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] irq: Fix some trivial typos in comments
In-Reply-To: <5260A6B0.4070509@infradead.org>
Message-ID: <alpine.LNX.2.00.1310181450050.31790@pobox.suse.cz>
References: <52608AB1.1010307@huawei.com> <52608AE4.9060304@huawei.com> <5260A6B0.4070509@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Randy Dunlap wrote:

> > ---
> >  kernel/irq/chip.c   |    2 +-
> >  kernel/irq/manage.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> > index a3bb14f..dc04c16 100644
> > --- a/kernel/irq/chip.c
> > +++ b/kernel/irq/chip.c
> > @@ -214,7 +214,7 @@ void irq_enable(struct irq_desc *desc)
> >  }
> > 
> >  /**
> > - * irq_disable - Mark interupt disabled
> > + * irq_disable - Mark interrupt disabled
> >   * @desc:	irq descriptor which should be disabled
> >   *
> >   * If the chip does not implement the irq_disable callback, we
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index 514bcfd..6394a3c 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -786,7 +786,7 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
> >  }
> > 
> >  /*
> > - * Interrupts explicitely requested as threaded interupts want to be
> > + * Interrupts explicitely requested as threaded interrupts want to be
> 
>                  explicitly

I have fixed this one and applied the series.

-- 
Jiri Kosina
SUSE Labs
