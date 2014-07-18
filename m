Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946048AbaGRT5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:57:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41257 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbaGRT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:57:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ZeGlUFGuYsfbPFg/D53BXibzjcMkcXuk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 551835AFBA9
Date: Fri, 18 Jul 2014 15:57:08 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        Catalin.Marinas@arm.com, Will.Deacon@arm.com, tglx@linutronix.de,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] irqchip: gicv2m: Clean up logic for detecting MSI
 support
Message-ID: <20140718195708.GH24496@titan.lakedaemon.net>
References: <1405689996-3601-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405689996-3601-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 08:26:36AM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> It's not quite clear that msi-controller is already checked
> by of_msi_chip_add. So, this patch add a note to clarify.
> 
> Also, clean up redundant logic and unnecessary pr_info.
> 
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
> 
> Note: This patch is created against irqchip/gic branch.
> 
>  drivers/irqchip/irq-gic-v2m.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Applied to the unstable branch irqchip/gic-v2m until Marc returns from
vacation.  Please see my email to MarkR on your previous series
regarding the re-shuffling of the branches.

thx,

Jason.
