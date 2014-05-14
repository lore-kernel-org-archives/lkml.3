Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaENXrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:47:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:48938 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaENXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:47:46 -0400
Date: Thu, 15 May 2014 01:47:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation
 facility
In-Reply-To: <5373AB71.3030705@tilera.com>
Message-ID: <alpine.DEB.2.02.1405150147180.6261@ionos.tec.linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154334.208629358@linutronix.de> <5373AB71.3030705@tilera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Chris Metcalf wrote:

> On 5/7/2014 11:44 AM, Thomas Gleixner wrote:
> > --- tip.orig/kernel/irq/Kconfig
> > +++ tip/kernel/irq/Kconfig
> > @@ -17,6 +17,11 @@ config GENERIC_IRQ_SHOW
> >   config GENERIC_IRQ_SHOW_LEVEL
> >          bool
> >   +# Facility to allocate an hardware interrupt. This is legacy support
> > +# and should not be used in new code. Use irq domains instead.
> > +config GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
> > +       bool
> 
> "a hardware interrupt".

I'll never get that right!
