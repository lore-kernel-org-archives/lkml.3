Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbaGQNfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:35:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10037 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932400AbaGQNfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:35:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/wI2NvI4SPNFREyQMjJDfHLuU3XF4gMrY=
X-DKIM: OpenDKIM Filter v2.0.1 titan C86455AE37C
Date: Thu, 17 Jul 2014 09:34:49 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/7] ARM: at91: move aic driver to drivers/irqchips
Message-ID: <20140717133449.GP13108@titan.lakedaemon.net>
References: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 07:14:15PM +0200, Boris BREZILLON wrote:
> Hello,
> 
> This series moves the AIC driver to the irqchip directory and make use of
> the generic chip framework whenever possible.
> 
> This driver only support DT boards (all legacy board files should be soon
> replaced by their DT versions).
> 
> Since the last version AIC and AIC5 code have been split and common
> functions have been moved to irq-atmel-aic-common.c.
> I know there is not much code in this file and it could have been
> duplicated in AIC and AIC5 drivers, but I'm planning to add more common
> stuff soon (AIC irq fixups previously done in
> arch/arm/mach-at91/sysirq_mask.c).
> 
> Jason, if everybody is fine with this version could you share a topic
> branch  containing patch 1 to 3 with Nicolas ?

I've now applied patches 1-3 to irqchip/atmel-aic.  You can find the
branch here:

  git://git.infradead.org/users/jcooper/linux.git irqchip/atmel-aic

It will be merged into -next today, and I'll merge it into irqchip/core
after a few days.

thx,

Jason.
