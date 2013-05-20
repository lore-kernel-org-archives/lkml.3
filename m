Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab3ETV1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:27:14 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33710 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab3ETV1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:27:12 -0400
Date: Mon, 20 May 2013 23:27:08 +0200
From: Simon Baatz <gmbnomis@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, David Miller <davem@davemloft.net>,
        Florian Fainelli <florian@openwrt.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] ARM: kirkwood: add gigabit ethernet and mvmdio
 device tree nodes
Message-ID: <20130520212708.GA26519@schnuecks.de>
References: <1365071235-11611-1-git-send-email-florian@openwrt.org>
 <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1367854420-8006-7-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367854420-8006-7-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Mon, May 06, 2013 at 05:33:39PM +0200, Sebastian Hesselbarth wrote:
> This patch adds mv643xx_eth and mvmdio device tree nodes for DT enabled
> Kirkwood boards. Phy nodes are also added with reg property set on a
> per-board basis.
...
> diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
> index fada7e6..c01a273 100644
> --- a/arch/arm/boot/dts/kirkwood.dtsi
> +++ b/arch/arm/boot/dts/kirkwood.dtsi
> @@ -202,5 +202,57 @@
>  			clocks = <&gate_clk 4>;
>  			status = "disabled";
>  		};
> +
> +		mdio: mdio-bus@72004 {
> +			compatible = "marvell,orion-mdio";
> +			reg = <0x72004 0x84>;
> +			interrupts = <11>;

Shouldn't this be 46?

- Simon

