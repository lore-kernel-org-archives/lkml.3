Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaKJXbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:31:48 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43243 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904AbaKJXbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:31:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187m2RtXnr0/Vf5jjg5XxJl
Date: Mon, 10 Nov 2014 15:30:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, linux@arm.linux.org.uk, tomi.valkeinen@ti.com,
        plagnioj@jcrosoft.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com
Subject: Re: [PATCH 3/4] arm: dts: omap3-gta04: Add handling for tv output
Message-ID: <20141110233050.GC31454@atomide.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
 <1415051968-4878-4-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415051968-4878-4-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [141103 14:01]:
> Add handling for gta04 tv out chain:
> venc -> opa362 -> svideo
> 
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dtsi | 48 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)

Applying this patch into omap-for-v3.19/dt thanks.

Tony
