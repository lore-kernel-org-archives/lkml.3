Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaLPIUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:20:35 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:47621 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbaLPIUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:20:33 -0500
Date: Tue, 16 Dec 2014 09:19:22 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Evgeni Dobrev <evgeni@studio-punkt.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 1/2] ARM: dts: kirkwood: enable phy driver for SATA
 controller on 88f6192
Message-ID: <20141216081922.GA1450@lunn.ch>
References: <20141215203724.GA22936@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215203724.GA22936@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 09:37:24PM +0100, Evgeni Dobrev wrote:
> This patch enables the phy drivers for the SATA controller on Marvell's 88f6192. Without them it is not possible to use SATA drives attached to this processor.
> 
> Signed-off-by: Evgeni Dobrev <evgeni@studio-punkt.com>

Acked-by: Andrew Lunn <andrew@lunn.ch>

This should also go to stable.

     Andrew


> ---
>  arch/arm/boot/dts/kirkwood-6192.dtsi |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/kirkwood-6192.dtsi b/arch/arm/boot/dts/kirkwood-6192.dtsi
> index dd81508..bed2dec 100644
> --- a/arch/arm/boot/dts/kirkwood-6192.dtsi
> +++ b/arch/arm/boot/dts/kirkwood-6192.dtsi
> @@ -66,6 +66,8 @@
>  			interrupts = <21>;
>  			clocks = <&gate_clk 14>, <&gate_clk 15>;
>  			clock-names = "0", "1";
> +                        phys = <&sata_phy0>, <&sata_phy1>;
> +                        phy-names = "port0", "port1";
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
