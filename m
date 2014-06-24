Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaFXMWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:22:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42217 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbaFXMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:22:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19YPPp/UOteOufGTrkymOjsKt/kKI6XS1U=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0FE99598632
Date: Tue, 24 Jun 2014 08:22:00 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, Catalin.Marinas@arm.com, Will.Deacon@arm.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] arm/gic: Add binding probe for GIC400
Message-ID: <20140624122200.GK10202@titan.lakedaemon.net>
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1403569980-12913-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403569980-12913-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suravee,

Please follow the convention for patch subject lines in this sub-system:

"irqchip: gic: ..."

thx,

Jason.

On Mon, Jun 23, 2014 at 07:32:59PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Add new Irqchip declaration for GIC400. This was mentioned in
> gic binding documentation, but there is not code to support it.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  drivers/irqchip/irq-gic.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 7e11c9d..adc86de 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -1071,6 +1071,8 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>  	gic_cnt++;
>  	return 0;
>  }
> +
> +IRQCHIP_DECLARE(arm_gic_400, "arm,gic-400", gic_of_init);
>  IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
>  IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
>  IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
> -- 
> 1.9.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
