Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaH0RSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:18:42 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:33793 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935525AbaH0RSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:18:40 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 13:18:39 EDT
Date: Wed, 27 Aug 2014 20:09:06 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net, linux@arm.linux.org.uk,
        shawn.guo@freescale.com, kernel@pengutronix.de, tony@atomide.com,
        catalin.marinas@arm.com, will.deacon@arm.com, jonas@southpole.se,
        tglx@linutronix.de, jason@lakedaemon.net, shc_work@mail.ru,
        baohua@kernel.org, maxime.ripard@free-electrons.com,
        khilman@linaro.org, sboyd@codeaurora.org, lorenzo.pieralisi@arm.com,
        larry.bassel@linaro.org, mark.rutland@arm.com, sudeep.holla@arm.com,
        vkale@apm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH v2 21/26] irqchip: or1k-pic: convert to handle_domain_irq
Message-ID: <20140827170905.GA5838@chokladfabriken.org>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
 <1409047421-27649-22-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409047421-27649-22-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:03:36AM +0100, Marc Zyngier wrote:
> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

This (and the other two openrisc related patches in this series) works fine
in my setup at least.

Acked-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
