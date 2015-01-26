Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbbAZUzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:55:19 -0500
Received: from smtp1.ore.mailhop.org ([54.68.34.165]:47442 "EHLO
	smtp1.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbbAZUzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:55:17 -0500
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX1/QEu0rRNiwlAF4EeYyOXVi
Date: Mon, 26 Jan 2015 12:51:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com, neilb@suse.de
Subject: Re: [PATCH 00/13] ARM: dts: omap3-gta04: Various DT fixes
Message-ID: <20150126205155.GG28663@atomide.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421959099-28319-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [150122 12:41]:
> This series contains fixes for gta04 devicetree. I collected patches
> from H. Nikolaus Schaller + NeilBrown and myself. Patches contains mostly fixes
> + adding new nodes and comments. All changes tested on gta04a4 board.
> 
> H. Nikolaus Schaller (5):
>   ARM: dts: omap3-gta04: Fix backup-battery charging in devicetree file.
>   ARM: dts: omap3-gta04: Fix audio node malformatting
>   ARM: dts: omap3-gta04: Enable mcbps2 necessary for audio
>   ARM: dts: omap3-gta04: Enable twl audio vibra support
>   ARM: dts: omap3-gta04: Enable power-off using twl4030
> 
> Marek Belisko (2):
>   ARM: dts: omap3-gta04: Fix a GPIO line for bma180 node
>   ARM: dts: omap3-gta04: Add ramp value for twl4030 audio
> 
> NeilBrown (6):
>   ARM: dts: omap3-gta04: add comments about gpios
>   ARM: dts: omap3-gta04: enable power-off for wifi card.
>   ARM: dts: omap3-gta04: add gyroscope
>   ARM: dts: omap3-gta04: only power DSS when necessary.
>   ARM: dts: omap3-gta04: uart4 is not connected, so mark it "disabled"

Applying all except the uart4 "disabled" patch into omap-for-v3.20/dt
thanks.

Tony

>   ARM: dts: omap3-gta04: Disable keypad
> 
>  arch/arm/boot/dts/omap3-gta04.dtsi | 54 +++++++++++++++++++++++++++-----------
>  1 file changed, 39 insertions(+), 15 deletions(-)
> 
> -- 
> 1.9.1
> 
