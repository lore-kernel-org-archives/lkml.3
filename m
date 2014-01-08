Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaAHTST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:18:19 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19514 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAHTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:18:15 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/PKuFOO0vtKAkeTiU7lK+C
Date: Wed, 8 Jan 2014 11:18:03 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sricharan R <r.sricharan@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, linux@arm.linux.org.uk, rnayak@ti.com,
        marc.zyngier@arm.com, grant.likely@linaro.org, mark.rutland@arm.com,
        robherring2@gmail.com, tglx@linutronix.de, galak@codeaurora.org,
        rob.herring@calxeda.com, nm@ti.com, bcousson@baylibre.com
Subject: Re: [PATCH V5 0/4] DRIVERS: IRQCHIP: Add support for crossbar IP
Message-ID: <20140108191802.GA31323@atomide.com>
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com>
 <52B168A5.4010202@ti.com>
 <52BBB614.5010707@ti.com>
 <52BC6B16.80507@ti.com>
 <52BD856E.7010609@ti.com>
 <52C11284.2030500@ti.com>
 <20140107230733.GD5074@atomide.com>
 <20140107235514.GG5074@atomide.com>
 <52CD5010.6030309@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CD5010.6030309@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sricharan R <r.sricharan@ti.com> [140108 05:20]:
> On Wednesday 08 January 2014 05:25 AM, Tony Lindgren wrote:
> > 
> > Oops, I noticed some errors on these:
> > 
> > WARNING: drivers/built-in.o(.text+0xcd0): Section mismatch in reference from the function irqcrossbar_init() to the function .init.text:crossbar_of_init()
> > The function irqcrossbar_init() references
> > the function __init crossbar_of_init().
> > This is often because irqcrossbar_init lacks a __init 
> > annotation or the annotation of crossbar_of_init is wrong.
> > 
> > WARNING: drivers/built-in.o(.text+0xcdc): Section mismatch in reference from the function irqcrossbar_init() to the (unknown reference) .init.rodata:(unknown)
> > The function irqcrossbar_init() references
> > the (unknown reference) __initconst (unknown).
> > This is often because irqcrossbar_init lacks a __initconst 
> > annotation or the annotation of (unknown) is wrong.
> > 
> > So I've dropped them for now. Care to fix up those errors and
> > base your patches against let's say v3.13-rc5?
> > 
>    Very Sorry for the section mismatch warning.
>    I have fixed it and pushed a new branch below based on v3.13-rc5
> 
>    git://github.com/Sricharanti/sricharan.git
>    branch: crossbar_3.13_rc5

Thanks, applying again.

Regards,

Tony
