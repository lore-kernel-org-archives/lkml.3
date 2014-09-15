Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaIOPcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:32:06 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59740 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752717AbaIOPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:32:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ODpTA1HGONVmtdUXGREQH
Date: Mon, 15 Sep 2014 08:31:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        bcousson@baylibre.com, linux@arm.linux.org.uk,
        khilman@deeprootsystems.com, tglx@linutronix.de,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/35] arm: omap: move intc to drivers/irqchip/
Message-ID: <20140915153145.GC2762@atomide.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <20140914051858.GF21986@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914051858.GF21986@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Cooper <jason@lakedaemon.net> [140913 22:19]:
> On Mon, Jul 28, 2014 at 04:15:48PM -0500, Felipe Balbi wrote:
> 
> For patches 32-35, please fix the subject line to:
> 
>   irqchip: omap-intc: C...
> 
> With that changed, patches 30-35 are:
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>

Great, thanks Jason for looking through them.

Felipe, can you please repost the missing patches with Jason's
changes and leaving out patch 30/35 to avoid board-*.c file
churn?

The branch to use for rebasing is omap-for-v3.18/intc-v2
that already contains the arch/arm/mach-omap2 related changes.

Regards,

Tony
