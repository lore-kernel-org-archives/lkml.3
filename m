Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaGWJCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:02:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29252 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGWJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:02:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ShT9lcMx26sDWa1hWW7bb
Date: Wed, 23 Jul 2014 02:00:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: bcousson@baylibre.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH v2 0/7] arm: dts: oma3-gta04: Various updates
Message-ID: <20140723090047.GD22006@atomide.com>
References: <1406057420-22269-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406057420-22269-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [140722 12:32]:
> Following patchset add various improvements to gta04 devicetree.
> 
> Changes from v1:
> - added description to all patches
> 
> Marek Belisko (7):
>   arm: dts: omap3-gta04: Add nand support
>   arm: dts: omap3-gta04: Fix magnetometer model
>   arm: dts: omap3-gta04: Add wifi reset node
>   arm: dts: omap3-gta04: Move spi gpio pins to pmx_core2
>   arm: dts: omap3-gta04: Add USB host support
>   arm: dts: omap3-gta04: Add display alias
>   arm: dts: omap3-gta04: Add twl4030 regulators parameters
> 
>  arch/arm/boot/dts/omap3-gta04.dts | 150 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 145 insertions(+), 5 deletions(-)

Applying into omap-for-v3.17/dt thanks.

Tony
