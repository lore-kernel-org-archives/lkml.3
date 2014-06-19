Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaFSLK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:10:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42188 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505AbaFSLKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:10:54 -0400
Message-ID: <53A2C52C.6020606@ti.com>
Date: Thu, 19 Jun 2014 14:10:36 +0300
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
Subject: Re: [PATCH v2 06/18] ARM: dts: DRA7: Add divider table to optfclk_pciephy_div
 clock
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-7-git-send-email-kishon@ti.com>
In-Reply-To: <1401345500-20188-7-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 09:38 AM, Kishon Vijay Abraham I wrote:
> From: Keerthy <j-keerthy@ti.com>
>
> Add divider table to optfclk_pciephy_div clock. The Documentation
> for divider clock can be found at ../clock/ti/divider.txt

This patch requires a better changelog. Why is the change done, any TRM 
refs etc.?

-Tero

>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tero Kristo <t-kristo@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/dra7xx-clocks.dtsi |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> index c767687..55e95c5 100644
> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> @@ -1170,6 +1170,7 @@
>   		clocks = <&apll_pcie_ck>;
>   		#clock-cells = <0>;
>   		reg = <0x021c>;
> +		ti,dividers = <2>, <1>;
>   		ti,bit-shift = <8>;
>   		ti,max-div = <2>;
>   	};
>

