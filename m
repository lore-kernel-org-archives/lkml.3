Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaKKPBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:01:16 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44408 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaKKPBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:01:14 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/9u1MgSS/qsKRUUKKXEqi+
Date: Tue, 11 Nov 2014 07:00:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, linux@arm.linux.org.uk, plagnioj@jcrosoft.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH 3/4] arm: dts: omap3-gta04: Add handling for tv output
Message-ID: <20141111150018.GL31454@atomide.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
 <1415051968-4878-4-git-send-email-marek@goldelico.com>
 <20141110233050.GC31454@atomide.com>
 <5461BDC6.7090308@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5461BDC6.7090308@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [141110 23:44]:
> Tony,
> 
> On 11/11/14 01:30, Tony Lindgren wrote:
> > * Marek Belisko <marek@goldelico.com> [141103 14:01]:
> >> Add handling for gta04 tv out chain:
> >> venc -> opa362 -> svideo
> >>
> >> Signed-off-by: Marek Belisko <marek@goldelico.com>
> >> ---
> >>  arch/arm/boot/dts/omap3-gta04.dtsi | 48 ++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 48 insertions(+)
> > 
> > Applying this patch into omap-for-v3.19/dt thanks.
> 
> There are changes needed for this series, so don't apply yet.
> 
> I'll try to find the time to do a review and send comments soon.

I've already pushed out the omap-for-v3.19/dt branch with
this patch buried in it. I'd rather not start redoing the
branch if the $subject patch is mostly correct and usable
with changes to the driver patches.

However, if the $subject patch needs to be redone for
the driver changes, let me know and I'll redo the branch.

Regards,

Tony
