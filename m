Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbaEGQaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:30:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:49173 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaEGQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:30:34 -0400
Date: Wed, 7 May 2014 18:30:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Helgaas <bhelgaas@google.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 08/32] x86: htirq: Use irq_alloc/free_irq()
In-Reply-To: <CAErSpo4=GUxUpAEtBH_=-DeXAij4zy+r15N4bjapY=54Y7x0Sg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1405071830120.6261@ionos.tec.linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154335.452206351@linutronix.de> <CAErSpo4=GUxUpAEtBH_=-DeXAij4zy+r15N4bjapY=54Y7x0Sg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Bjorn Helgaas wrote:

> On Wed, May 7, 2014 at 9:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > No functional change, just cleaned up a bit.
> >
> > This does not replace the requirement to move x86 to irq domains, but
> > it limits the mess to some degree.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> I assume you'll merge this along with the rest of your series.  Let me
> know if you need me to do anything.

Yes, I'll take the whole lot when nobody screams

Thanks,

	tglx
