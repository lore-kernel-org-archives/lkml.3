Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaGQMxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:53:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29804 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755046AbaGQMxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:53:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18yB0yhioHRIrZzdlWb9DUI9SNwHfW99BA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 395505AE288
Date: Thu, 17 Jul 2014 08:53:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        Catalin.Marinas@arm.com, Will.Deacon@arm.com, tglx@linutronix.de,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/4 V3] irqchip: gicv2m: Add support for multiple MSI
 for ARM64 GICv2m
Message-ID: <20140717125309.GK13108@titan.lakedaemon.net>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1404947104-21345-5-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404947104-21345-5-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suravee,

On Wed, Jul 09, 2014 at 06:05:04PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch extend GICv2m MSI to support multiple MSI in ARM64.
> 
> This requires the common arch_setup_msi_irqs() to be overwriten
> with ARM64 version which does not return 1 for PCI_CAP_ID_MSI and
> nvec > 1.
> 
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  arch/arm64/include/asm/msi.h  | 15 ++++++++
>  arch/arm64/kernel/Makefile    |  1 +
>  arch/arm64/kernel/msi.c       | 57 ++++++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v2m.c | 80 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 153 insertions(+)
>  create mode 100644 arch/arm64/include/asm/msi.h
>  create mode 100644 arch/arm64/kernel/msi.c

With the Subject line nit fixed ("irqchip: gic-v2m: ..."),

Acked-by: Jason Cooper <jason@lakedaemon.net>

Please route as you see fit.

thx,

Jason.
