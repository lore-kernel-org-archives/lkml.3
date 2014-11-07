Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaKGFA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:00:26 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44125 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbaKGFAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:00:23 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19QfMO2roM4AJ+pb3AcN6O5Ox5Qg4gUKyA=
X-DKIM: OpenDKIM Filter v2.0.1 titan B8590614035
Date: Fri, 7 Nov 2014 00:00:09 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        ralf@linux-mips.org, linux-sh@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V3 00/14] genirq endian fixes; bcm7120/brcmstb IRQ
 updates
Message-ID: <20141107050009.GI3698@titan.lakedaemon.net>
References: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

On Sat, Nov 01, 2014 at 06:03:47PM -0700, Kevin Cernekee wrote:
...
> Kevin Cernekee (14):
>   sh: Eliminate unused irq_reg_{readl,writel} accessors
>   genirq: Generic chip: Change irq_reg_{readl,writel} arguments
>   genirq: Generic chip: Allow irqchip drivers to override
>     irq_reg_{readl,writel}
>   genirq: Generic chip: Add big endian I/O accessors
>   irqchip: brcmstb-l2: Eliminate dependency on ARM code
>   irqchip: bcm7120-l2: Eliminate bad IRQ check
>   irqchip: bcm7120-l2, brcmstb-l2: Remove ARM Kconfig dependency
>   irqchip: bcm7120-l2: Make sure all register accesses use base+offset
>   irqchip: bcm7120-l2: Fix missing nibble in gc->unused mask
>   irqchip: bcm7120-l2: Use gc->mask_cache to simplify suspend/resume
>     functions
>   irqchip: bcm7120-l2: Extend driver to support 64+ bit controllers
>   irqchip: bcm7120-l2: Decouple driver from brcmstb-l2
>   irqchip: bcm7120-l2: Convert driver to use irq_reg_{readl,writel}
>   irqchip: brcmstb-l2: Convert driver to use irq_reg_{readl,writel}

Patches 2, 3, and 4 applied to irqchip/core with Thomas' and Arnd's Acks
added.  Patches 5-$ added to irqchip/core with Arnd's Ack added where it
was missing.

I've left patch #1 for the sh maintainers.

thx,

Jason.
