Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaENNXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:23:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43639 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaENNXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:23:48 -0400
Message-ID: <53736E47.4070402@ti.com>
Date: Wed, 14 May 2014 16:23:19 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 11/17] ARM: dts: dra7xx-clocks: Add missing 32khz clocks
 used for PHY
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-12-git-send-email-kishon@ti.com>
In-Reply-To: <1399383244-14556-12-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,


On 05/06/2014 04:33 PM, Kishon Vijay Abraham I wrote:
> Added missing 32khz clock used by PCIe PHY.
> The documention for this node can be found @ ../bindings/clock/ti/gate.txt.

Typo in $subject
s/clocks/clock

--
cheers,
-roger

> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tero Kristo <t-kristo@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/dra7xx-clocks.dtsi |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> index 44993ec..e1bd052 100644
> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> @@ -1165,6 +1165,14 @@
>  		reg = <0x021c>, <0x0220>;
>  	};
>  
> +	optfclk_pciephy_32khz: optfclk_pciephy_32khz@4a0093b0 {
> +		compatible = "ti,gate-clock";
> +		clocks = <&sys_32k_ck>;
> +		#clock-cells = <0>;
> +		reg = <0x13b0>;
> +		ti,bit-shift = <8>;
> +	};
> +
>  	optfclk_pciephy_div: optfclk_pciephy_div@4a00821c {
>  		compatible = "ti,divider-clock";
>  		clocks = <&apll_pcie_ck>;
> 

