Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaHZQxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:53:45 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:40426 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752447AbaHZQxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:53:42 -0400
Date: Tue, 26 Aug 2014 17:53:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux@openrisc.net" <linux@openrisc.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "tony@atomide.com" <tony@atomide.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "jonas@southpole.se" <jonas@southpole.se>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "baohua@kernel.org" <baohua@kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "khilman@linaro.org" <khilman@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "larry.bassel@linaro.org" <larry.bassel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "stefan.kristiansson@saunalahti.fi" 
	<stefan.kristiansson@saunalahti.fi>,
        "vkale@apm.com" <vkale@apm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2 25/26] arm64: get rid of handle_IRQ
Message-ID: <20140826165304.GN16482@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
 <1409047421-27649-26-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409047421-27649-26-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:03:40AM +0100, Marc Zyngier wrote:
> All the arm64 irqchip drivers have been converted to handle_domain_irq,
> making it possible to remove the handle_IRQ stub entierely.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
