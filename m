Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaFEQjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:39:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46289 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaFEQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:39:14 -0400
Message-ID: <1401986347.4103.11.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 3/9] ARM: dts: berlin: add a required reset property in
 the chip controller node
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Jun 2014 18:39:07 +0200
In-Reply-To: <1401983326-19205-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
	 <1401983326-19205-4-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 05.06.2014, 17:48 +0200 schrieb Antoine Ténart:
> The chip controller node now also describes the Marvell Berlin reset
> controller. Add the required 'reset-cells' property.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  arch/arm/boot/dts/berlin2.dtsi   | 1 +
>  arch/arm/boot/dts/berlin2cd.dtsi | 1 +
>  arch/arm/boot/dts/berlin2q.dtsi  | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 2477dac4d643..379ff1a38377 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
> @@ -243,6 +243,7 @@
>  		chip: chip-control@ea0000 {
>  			compatible = "marvell,berlin2-chip-ctrl";
>  			#clock-cells = <1>;
> +			#reset-cells = <1>;

Are the marvell,berlin2q-chip-ctrl bindings already documented? This
should also be added to the documentation.

regards
Philipp

