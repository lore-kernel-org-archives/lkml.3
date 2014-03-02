Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaCBRoD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 12:44:03 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40512 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752463AbaCBRn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 12:43:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19xi+6T91l4mRSO+efTaFoV
Date: Sun, 2 Mar 2014 09:43:37 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH v2 0/7] ARM: dts: omap3-gta04: Various devicetree updates
Message-ID: <20140302174336.GC18496@atomide.com>
References: <1393682334-26805-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393682334-26805-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [140301 06:02]:
> This updated series fix issue with proper gta04 booting in 3.14 kernel
> and add various devices to devicetree.
> 
> Changes from V1: 
> - removed fixes which was merged to 3.14 already
> - add bma180 accelerometer + booting fix
> 
> Marek Belisko (2):
>   ARM: dts: omap3-gta04: Add ti,omap36xx to compatible property to avoid
>     problems with booting
>   ARM: dts: omap3-gta04: Add touchscreen properties
> 
> NeilBrown (5):
>   ARM: dts: omap3-gta04: Add support for magnetometer
>   ARM: dts: omap3-gta04: Add twl4030 charger
>   ARM: dts: omap3-gta04: Add basic sound support
>   ARM: dts: omap3-gta04: Enable mmc2 for wifi
>   ARM: dts: omap3-gta04: Add bma180 accelerometer
> 
>  arch/arm/boot/dts/omap3-gta04.dts | 53 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 51 insertions(+), 2 deletions(-)

Thanks for updating these, I'll take the first one into
omap-for-v3.14/fixes and the rest into omap-for-v3.15/dt.

Regards,

Tony
