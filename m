Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaEMTTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:19:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58894 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaEMTTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:19:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/3zZEPtphQLAlyTh+6NSpSdUkpxM0BzZE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8B59657445B
Date: Tue, 13 May 2014 15:19:06 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/7] irqchip: s3c24xx: fix function type for
 IRQCHIP_OF_DECLARE
Message-ID: <20140513191906.GI27822@titan.lakedaemon.net>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
 <1399940993-1773-6-git-send-email-robherring2@gmail.com>
 <20140513152233.GB27822@titan.lakedaemon.net>
 <CAL_JsqJuYwkyy0UO75D1XmAKZa3ui3zYYBi55xFOWUFVgFw5=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJuYwkyy0UO75D1XmAKZa3ui3zYYBi55xFOWUFVgFw5=g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:02:06PM -0500, Rob Herring wrote:
> On Tue, May 13, 2014 at 10:22 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > Rob,
> >
> > On Mon, May 12, 2014 at 07:29:51PM -0500, Rob Herring wrote:
> >> From: Rob Herring <robh@kernel.org>
> >>
> >> Adding function type checking to IRQCHIP_OF_DECLARE found a type mismatch
> >> with s3c2410_init_intc_of and s3c2416_init_intc_of. The function only takes
> >> the 1st 2 parameters.
> >>
> >> Signed-off-by: Rob Herring <robh@kernel.org>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> ---
> >>  drivers/irqchip/irq-s3c24xx.c | 6 ++----
> >>  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > Thomas has asked me to give him a hand with the patches for
> > drivers/irqchip.  When you add these two to your tree, could you amend
> > the subject line to conform with the other patches in that directory?
> 
> Excellent! We've needed some help there for a long time. Is there a
> patch in flight to add this to MAINTAINERS.

See:

  https://lkml.kernel.org/r/1400006821-32145-1-git-send-email-jason@lakedaemon.net

and it's now in irq/urgent in the tip tree.

thx,

Jason.
