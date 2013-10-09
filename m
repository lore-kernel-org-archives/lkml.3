Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3JINMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:12:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:22841 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3JINMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:12:23 -0400
Message-ID: <52555634.7020500@atmel.com>
Date: Wed, 9 Oct 2013 15:12:20 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/6] ARM: at91/dt: define sama5d3xek's main clk frequency
References: <1375951572-10829-1-git-send-email-b.brezillon@overkiz.com> <1375954563-11343-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375954563-11343-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 11:36, Boris BREZILLON :
> Define the main clock frequency for the new main clock node
> in sama5d3xcm.dtsi.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   arch/arm/boot/dts/sama5d3xcm.dtsi |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
> index 6a1871b..f19d5bf 100644
> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
> @@ -38,6 +38,12 @@
>   			macb0: ethernet@f0028000 {
>   				phy-mode = "rgmii";
>   			};
> +
> +			pmc: pmc@fffffc00 {
> +				main: mainck {
> +					clock-frequency = <12000000>;
> +				};
> +			};
>   		};
>
>   		nand0: nand@60000000 {
>


-- 
Nicolas Ferre
