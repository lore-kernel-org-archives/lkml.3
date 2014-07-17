Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbaGQMs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:48:27 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19886 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756242AbaGQMsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:48:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18N8GGo+lxVqzejxK34P4UvtzmPacXsCIk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2166C5AE24B
Date: Thu, 17 Jul 2014 08:48:04 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: suravee.suthikulpanit@amd.com, linux-arm-kernel@lists.infradead.org,
        marc.zyngier@arm.com, mark.rutland@arm.com, devicetree@vger.kernel.org,
        pawel.moll@arm.com, linux-doc@vger.kernel.org, Catalin.Marinas@arm.com,
        Harish.Kasiviswanathan@amd.com, linux-kernel@vger.kernel.org,
        Will.Deacon@arm.com, linux-pci@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] irqchip: gic: Add binding probe for ARM GIC400
Message-ID: <20140717124804.GI13108@titan.lakedaemon.net>
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1404947104-21345-2-git-send-email-suravee.suthikulpanit@amd.com>
 <2932284.F1eaAf8ArJ@diego>
 <2621565.f5eISveXXJ@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <2621565.f5eISveXXJ@diego>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:03:03AM +0200, Heiko Stübner wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Commit 3ab72f9156bb "dt-bindings: add GIC-400 binding" added the
> "arm,gic-400" compatible string, but the corresponding IRQCHIP_DECLARE
> was never added to the gic driver.
> 
> Therefore add the missing irqchip declaration for it.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Removed additional empty line and adapted commit message to mark it
> as fixing an issue.
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
> As I really need this, I took the liberty of adapting the patch accordingly
> to make it apply on top of the current irqchip/for-next (or urgent) and
> explicitly state the fixed issue. Hope that is ok
> 
>  drivers/irqchip/irq-gic.c | 1 +
>  1 file changed, 1 insertion(+)

Applied to irqchip/urgent with Will's Ack and Cc'd to stable for v3.14+

thx,

Jason.
