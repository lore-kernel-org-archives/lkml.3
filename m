Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbaGQNTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:19:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40507 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbaGQNTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:19:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18b9Jq/h40lMjXmVgjsQuwyTMV+9b6Ekuk=
X-DKIM: OpenDKIM Filter v2.0.1 titan A5B445AE2F7
Date: Thu, 17 Jul 2014 09:18:54 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        Catalin.Marinas@arm.com, Will.Deacon@arm.com, tglx@linutronix.de,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/4 V3] irqchip: gic: Introduce ARM GICv2m MSI(-X)
 support
Message-ID: <20140717131854.GN13108@titan.lakedaemon.net>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 06:05:00PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch set introduces support for MSI(-X) in GICv2m specification,
> which is implemented in some variation of GIC400.
> 
> This depends on and has been tested with the V7 of"Add support for PCI in AArch64"
> (https://lkml.org/lkml/2014/3/14/320).
> 
> Changes in V3:
>     * Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/gic
>       (per Jason Cooper request)
>     * Misc fix/clean up per Mark Rutland comments
>     * Minor Clean up in the driver/irqchip/irq-gic-v2m.c: alloc_msi_irqs()
>     * Patch 4 is new to the series:
>         * Add ARM64-specific version arch_setup_msi_irqs() to allow support
>           for Multiple MSI.
>         * Add support for Multiple MSI for GICv2m.
> 
> Suravee Suthikulpanit (4):
>   irqchip: gic: Add binding probe for ARM GIC400
>   irqchip: gic: Restructuring ARM GIC code
>   irqchip: gic: Add supports for ARM GICv2m MSI(-X)
>   irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m

Ok, patch #1 applied to irqchip/urgent.  Patches 2 and 3 applied to
irqchip/gic with irqchip/urgent merged in.  To facilitate
testing/merging, I've prepared an unsigned tag for you on the
irqchip/gic branch:

  git://git.infradead.org/users/jcooper/linux.git tags/deps-irqchip-gic-3.17-2

Unless you tell me I broke something horribly, this tag and irqchip/gic
up to that point are stable.

thx,

Jason.
