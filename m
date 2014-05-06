Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851AbaEFLEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:04:35 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:32502
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934579AbaEFLEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:04:31 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(zzbb2dI98dI9371Ie0eah1432I4015Ic8kzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h27e2h2673i19b6n)
Date: Tue, 6 May 2014 13:04:22 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: zynq: dt: Clean up device tree
References: <1399310168-6099-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1399310168-6099-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <cb504244-1639-4ad9-97c3-4258507fb647@CO9EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 07:16 PM, Soren Brinkmann wrote:
>  - Use generic node names
>  - Fix up some weird formatting and white spaces
>  - Update copyright info
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> 
>  arch/arm/boot/dts/zynq-7000.dtsi | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index c1176abc34d9..bed6e0aed00a 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -1,5 +1,5 @@
>  /*
> - *  Copyright (C) 2011 Xilinx
> + *  Copyright (C) 2011 - 2014 Xilinx
>   *
>   * This software is licensed under the terms of the GNU General Public
>   * License version 2, as published by the Free Software Foundation, and
> @@ -55,7 +55,7 @@
>  		interrupt-parent = <&intc>;
>  		ranges;
>  
> -		i2c0: zynq-i2c@e0004000 {
> +		i2c0: i2c@e0004000 {
>  			compatible = "cdns,i2c-r1p10";
>  			status = "disabled";
>  			clocks = <&clkc 38>;
> @@ -66,7 +66,7 @@
>  			#size-cells = <0>;
>  		};
>  
> -		i2c1: zynq-i2c@e0005000 {
> +		i2c1: i2c@e0005000 {
>  			compatible = "cdns,i2c-r1p10";
>  			status = "disabled";
>  			clocks = <&clkc 39>;
> @@ -95,7 +95,7 @@
>  			cache-level = <2>;
>  		};
>  
> -		uart0: uart@e0000000 {
> +		uart0: serial@e0000000 {
>  			compatible = "xlnx,xuartps";
>  			status = "disabled";
>  			clocks = <&clkc 23>, <&clkc 40>;
> @@ -104,7 +104,7 @@
>  			interrupts = <0 27 4>;
>  		};
>  
> -		uart1: uart@e0001000 {
> +		uart1: serial@e0001000 {
>  			compatible = "xlnx,xuartps";
>  			status = "disabled";
>  			clocks = <&clkc 24>, <&clkc 41>;
> @@ -131,7 +131,7 @@
>  			clock-names = "pclk", "hclk", "tx_clk";
>  		};
>  
> -		sdhci0: ps7-sdhci@e0100000 {
> +		sdhci0: sdhci@e0100000 {
>  			compatible = "arasan,sdhci-8.9a";
>  			status = "disabled";
>  			clock-names = "clk_xin", "clk_ahb";
> @@ -141,7 +141,7 @@
>  			reg = <0xe0100000 0x1000>;
>  		} ;
>  
> -		sdhci1: ps7-sdhci@e0101000 {
> +		sdhci1: sdhci@e0101000 {
>  			compatible = "arasan,sdhci-8.9a";
>  			status = "disabled";
>  			clock-names = "clk_xin", "clk_ahb";
> @@ -185,26 +185,27 @@
>  			clocks = <&clkc 4>;
>  		};
>  
> -		ttc0: ttc0@f8001000 {
> +		ttc0: timer@f8001000 {
>  			interrupt-parent = <&intc>;
> -			interrupts = < 0 10 4 0 11 4 0 12 4 >;
> +			interrupts = <0 10 4>, <0 11 4>, <0 12 4>;
>  			compatible = "cdns,ttc";
>  			clocks = <&clkc 6>;
>  			reg = <0xF8001000 0x1000>;
>  		};
>  
> -		ttc1: ttc1@f8002000 {
> +		ttc1: timer@f8002000 {
>  			interrupt-parent = <&intc>;
> -			interrupts = < 0 37 4 0 38 4 0 39 4 >;
> +			interrupts = <0 37 4>, <0 38 4>, <0 39 4>;
>  			compatible = "cdns,ttc";
>  			clocks = <&clkc 6>;
>  			reg = <0xF8002000 0x1000>;
>  		};
> -		scutimer: scutimer@f8f00600 {
> +
> +		scutimer: timer@f8f00600 {
>  			interrupt-parent = <&intc>;
> -			interrupts = < 1 13 0x301 >;
> +			interrupts = <1 13 0x301>;
>  			compatible = "arm,cortex-a9-twd-timer";
> -			reg = < 0xf8f00600 0x20 >;
> +			reg = <0xf8f00600 0x20>;
>  			clocks = <&clkc 4>;
>  		} ;
>  	};
> 

Looks good to me. Applied to zynq/dt branch.

Thanks,
Michal


