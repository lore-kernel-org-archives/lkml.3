Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaGHWhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:37:24 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:65534 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752158AbaGHWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:37:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+t+3xl0HQ151894BIqhBtGMs45vJfYy2c=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5D26C5A5CCD
Date: Tue, 8 Jul 2014 18:37:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        Catalin.Marinas@arm.com, Will.Deacon@arm.com, tglx@linutronix.de,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/3 V2] irqchip: gic: Introduce ARM GICv2m MSI(-X)
 support
Message-ID: <20140708223709.GH13433@titan.lakedaemon.net>
References: <1404314468-7674-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404314468-7674-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suravee,

On Wed, Jul 02, 2014 at 10:21:05AM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch set introduces support for MSI(-X) in GICv2m specification,
> which is implemented in some variation of GIC400 (e.g. gic-400+).
> 
> This depends on and has been tested with the V7 of "Add support for PCI in AArch64"
> (https://lkml.org/lkml/2014/3/14/320).
> 
> Changes in V2:
> Re-architect the code to:
>     * Use irq_chip for gicv2m instead of using the gic_chip (per Marc suggestion).
>     * Remove the overwriting of arch_setup_msi_irq and arch_setup_msi_irqs
>       (per Marc suggestion).
>     * Add devicetree matching for gic-400-plus for v2m stuff instread of
>       re-using gic-400 just to be clear.
>     * Misc fix/clean up per Mark Rutland and Marc Zyngier comments
> 
> Suravee Suthikulpanit (3):
>   irqchip: gic: Add binding probe for ARM GIC400
>   irqchip: gic: Restructuring ARM GIC code
>   irqchip: gic: Add supports for ARM GICv2m MSI(-X)

I've now pulled in the first two patches of Marc's series into
irqchip/gic.  Could you please rebase your changes on top of that?

Also, please get a handle on git send-email.  This series had broken
threading and was sent out of order.

thx,

Jason.
