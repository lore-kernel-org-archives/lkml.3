Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaGHW4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:56:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45620 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbaGHW4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:56:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+cAtUIUHfnrEvosa4U9chs+51Tq3yIAh4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 23C765A5D52
Date: Tue, 8 Jul 2014 18:56:20 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+uevicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, marc.zyngier@arm.com,
        david.vrabel@citrix.com, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: gic: Add support for cortex a7 compatible
 string
Message-ID: <20140708225620.GL13433@titan.lakedaemon.net>
References: <1404388732-28890-1-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404388732-28890-1-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 01:58:52PM +0200, Matthias Brugger wrote:
> Patch 0a68214b "ARM: DT: Add binding for GIC virtualization extentions (VGIC)" added
> the "arm,cortex-a7-gic" compatible string, but the corresponding IRQCHIP_DECLARE
> was never added to the gic driver.
> 
> To let real Cortex-A7 SoCs use it, add the necessary declaration to the device driver.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  drivers/irqchip/irq-gic.c |    1 +
>  1 file changed, 1 insertion(+)

Applied to irqchip/urgent and Cc'd to stable for v3.5+

thx,

Jason.
