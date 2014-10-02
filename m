Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaJBTSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:18:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42204 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbaJBTSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:18:46 -0400
Message-ID: <542DA4F6.2020009@ti.com>
Date: Thu, 2 Oct 2014 15:18:14 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v1 4/4] ARM: dts: k2hk-evm: attach net, qmss and knav_dmas
 to keystone-gpc
References: <1412001499-19369-1-git-send-email-grygorii.strashko@ti.com> <1412001499-19369-5-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1412001499-19369-5-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 10:38 AM, Grygorii Strashko wrote:
> Attach Keystone 2s nodes for NetCP, NetCPx, QMSS, KNAV-DMA devices
> to the TI Keystone 2 Generic PM Controller.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  arch/arm/boot/dts/k2hk-evm.dts | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/k2hk-evm.dts b/arch/arm/boot/dts/k2hk-evm.dts
> index 91371f7..c1ceaa2 100644
> --- a/arch/arm/boot/dts/k2hk-evm.dts
> +++ b/arch/arm/boot/dts/k2hk-evm.dts
> @@ -58,6 +58,7 @@
>  				clock-output-names = "refclk-ddr3b";
>  			};
>  		};
> +
Stray change ?

>  		qmss: qmss@2a40000 {
>  			compatible = "ti,keystone-navigator-qmss";
>  			dma-coherent;
> @@ -65,6 +66,8 @@
>  			#size-cells = <1>;
>  			clocks = <&chipclk13>;
>  			ranges;
> +			power-domains = <&pm_controller>;
> +
>  			queue-range	= <0 0x4000>;
>  			linkram0	= <0x100000 0x8000>;
>  			linkram1	= <0x0 0x10000>;
> @@ -198,6 +201,8 @@
>  			#address-cells = <1>;
>  			#size-cells = <1>;
>  			ranges;
> +			power-domains = <&pm_controller>;
> +
>  			ti,navigator-cloud-address = <0x23a80000 0x23a90000
>  						   0x23aa0000 0x23ab0000>;
>  
> @@ -229,6 +234,7 @@
>  			#address-cells = <1>;
>  			#size-cells = <1>;
>  			ranges;
> +			power-domains = <&pm_controller>;
>  
>  			clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
>  			dma-coherent;
> @@ -307,6 +313,7 @@
>  			#address-cells = <1>;
>  			#size-cells = <1>;
>  			ranges;
> +			power-domains = <&pm_controller>;
>  
>  			clocks = <&clkxge>;
>  			clock-names = "clk_xge";
> 

