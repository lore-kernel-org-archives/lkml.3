Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbaFSLNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:13:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42781 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbaFSLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:13:09 -0400
Message-ID: <53A2C5B4.9080300@ti.com>
Date: Thu, 19 Jun 2014 14:12:52 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        Keerthy <j-keerthy@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v2 07/18] ARM: dts: DRA7: Change the parent of apll_pcie_in_clk_mux
 to dpll_pcie_ref_m2ldo_ck
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-8-git-send-email-kishon@ti.com>
In-Reply-To: <1401345500-20188-8-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 09:38 AM, Kishon Vijay Abraham I wrote:
> From: Keerthy <j-keerthy@ti.com>
>
> Change the parent of apll_pcie_in_clk_mux to dpll_pcie_ref_m2ldo_ck
> from dpll_pcie_ref_ck.

Why? Needs a better changelog also.

-Tero

>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tero Kristo <t-kristo@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/dra7xx-clocks.dtsi |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> index 55e95c5..44993ec 100644
> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> @@ -1152,7 +1152,7 @@
>
>   	apll_pcie_in_clk_mux: apll_pcie_in_clk_mux@4ae06118 {
>   		compatible = "ti,mux-clock";
> -		clocks = <&dpll_pcie_ref_ck>, <&pciesref_acs_clk_ck>;
> +		clocks = <&dpll_pcie_ref_m2ldo_ck>, <&pciesref_acs_clk_ck>;
>   		#clock-cells = <0>;
>   		reg = <0x021c 0x4>;
>   		ti,bit-shift = <7>;
>

