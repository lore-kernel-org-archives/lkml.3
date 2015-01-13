Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbbAMQAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:00:31 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42967 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752295AbbAMQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:00:27 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/mVo2imheV9p+/G55siZ3m
Date: Tue, 13 Jan 2015 07:56:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Marek Belisko <marek@goldelico.com>, plagnioj@jcrosoft.com,
        bcousson@baylibre.com, hns@goldelico.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v4 3/3] arm: dts: omap3-gta04: Add handling for tv output
Message-ID: <20150113155634.GD2419@atomide.com>
References: <1417642402-20538-1-git-send-email-marek@goldelico.com>
 <1417642402-20538-4-git-send-email-marek@goldelico.com>
 <54B4EF43.50300@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B4EF43.50300@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [150113 02:14]:
> On 03/12/14 23:33, Marek Belisko wrote:
> > Add handling for gta04 tv out chain:
> > venc -> opa362 -> svideo
> > 
> > Use invert-polarity in venc node because opa362
> > is doing polarity inversion also.
> > 
> > Signed-off-by: Marek Belisko <marek@goldelico.com>
> > ---
> >  arch/arm/boot/dts/omap3-gta04.dtsi | 49 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> 
> Looks fine to me.
> 
> Tony, do you want to pick this up? I can take the first two patches via
> fbdev.

OK will pick the dtsi change.

Thanks,

Tony
