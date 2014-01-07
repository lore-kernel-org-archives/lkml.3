Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaAGXHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:07:51 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57916 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbaAGXHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:07:42 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1879/eBLBHNbE8LOIWPRyPC
Date: Tue, 7 Jan 2014 15:07:34 -0800
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
Message-ID: <20140107230733.GD5074@atomide.com>
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com>
 <52B168A5.4010202@ti.com>
 <52BBB614.5010707@ti.com>
 <52BC6B16.80507@ti.com>
 <52BD856E.7010609@ti.com>
 <52C11284.2030500@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C11284.2030500@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sricharan R <r.sricharan@ti.com> [131229 22:30]:
> On Friday 27 December 2013 07:19 PM, Sricharan R wrote:
> > On Thursday 26 December 2013 11:14 PM, Santosh Shilimkar wrote:
> >> On Wednesday 25 December 2013 11:52 PM, Sricharan R wrote:
> >>> On Wednesday 18 December 2013 02:49 PM, Sricharan R wrote:
> >>>> I have addressed all the comments on this series, can this be merged now ?
> >>>>
> >>>   Ping..
> >>>
> >> Thomas has already given his reviewed-by tag so the patches can be
> >> taken via arm-soc tree considering OMAP and GIC changes. Can you
> >> create a branch with all these patches applied and send it
> >> to Tony ?
> >>
> > Ok, i will send out a branch for this.
> > 
>  
>  I have pushed the below branch
> 
> git://github.com/Sricharanti/sricharan.git
> branch: crossbar
> 
> This is on top of Tony's linux-omap master branch

The linux-omap master branch cannot be used as a base as it
contains tons of commit history not in mainline. So I'll
manually applied these patches into omap-for-v3.14/crosbar
branch.

Regards,

Tony
