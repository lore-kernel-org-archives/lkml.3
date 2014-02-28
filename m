Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaB1Vgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:36:48 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29754 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaB1Vgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:36:45 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19/2mNzOlTZ934w/Li3oBvx
Date: Fri, 28 Feb 2014 13:36:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sricharan R <r.sricharan@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, linux@arm.linux.org.uk, rnayak@ti.com,
        marc.zyngier@arm.com, grant.likely@linaro.org, mark.rutland@arm.com,
        robherring2@gmail.com, galak@codeaurora.org, rob.herring@calxeda.com,
        santosh.shilimkar@ti.com, nm@ti.com, bcousson@baylibre.com,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V5 2/4] DRIVERS: IRQCHIP: CROSSBAR: Add support for
 Crossbar IP
Message-ID: <20140228213629.GB13624@atomide.com>
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com>
 <1386066445-28245-3-git-send-email-r.sricharan@ti.com>
 <52D7B2CA.8080902@ti.com>
 <52EF7D85.5070705@ti.com>
 <alpine.DEB.2.02.1402041713470.24986@ionos.tec.linutronix.de>
 <52F23887.9060209@ti.com>
 <52F24683.9060200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F24683.9060200@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sricharan R <r.sricharan@ti.com> [140205 06:13]:
> Tony,
> 
> On Wednesday 05 February 2014 06:41 PM, Sricharan R wrote:
> > On Tuesday 04 February 2014 09:44 PM, Thomas Gleixner wrote:
> >> On Mon, 3 Feb 2014, Sricharan R wrote:
> >>>> I already have your reviewed-by tag for the first patch in this series.
> >>>>
> >>>> Kevin was pointing out that irqchip maintainer tag is needed for this patch as well
> >>>> to be merged. We are planning to take this series through arm-soc tree.
> >>>>
> >>>> Can i please have your tag for this patch as well ?
> >>
> >> Acked-by-me
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > Thanks Thomas.
> > 
> > Kevin,
> >     I will re-send a branch based on rc1 for this.
> > 
> 
> I have pushed a branch based on mainline,
>    git://github.com/Sricharanti/sricharan.git
>    branch: crossbar_3.14_rc1

OK pulling into omap-for-v3.15/crossbar thanks.

Tony
