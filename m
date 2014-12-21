Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaLUMpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:45:07 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:49260 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaLUMpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:45:04 -0500
Date: Sun, 21 Dec 2014 13:43:44 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Evgeni Dobrev <evgeni@studio-punkt.com>
Cc: devicetree@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2 1/1] ARM: dts: kirkwood: enable phy driver for SATA
 controller on 88f6192
Message-ID: <20141221124344.GA29602@lunn.ch>
References: <20141215203724.GA22936@anne>
 <20141216182217.GA20696@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216182217.GA20696@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 07:22:18PM +0100, Evgeni Dobrev wrote:
> This patch enables the phy drivers for the SATA controller on Marvell's 88f6192.
> Without them it is not possible to use SATA drives attached to this processor.
> 
> Signed-off-by: Evgeni Dobrev <evgeni@studio-punkt.com>

Hi Evgeni

Added to mvebu/dt

      Andrew

> ---
>  arch/arm/boot/dts/kirkwood-6192.dtsi |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/kirkwood-6192.dtsi b/arch/arm/boot/dts/kirkwood-6192.dtsi
> index dd81508..9e6e9e2 100644
> --- a/arch/arm/boot/dts/kirkwood-6192.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-6192.dtsi
> @@ -66,6 +66,8 @@
>  			interrupts = <21>;
>  			clocks = <&gate_clk 14>, <&gate_clk 15>;
>  			clock-names = "0", "1";
> +			phys = <&sata_phy0>, <&sata_phy1>;
> +			phy-names = "port0", "port1";
>  			status = "disabled";
>  		};
>  
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
