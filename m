Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3JINOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:14:32 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:13459 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab3JINOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:14:30 -0400
Message-ID: <525556B4.4020809@atmel.com>
Date: Wed, 9 Oct 2013 15:14:28 +0200
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
Subject: Re: [PATCH 6/6] ARM: at91/dt: remove old main clk definition from
 sama5d3xcm.dtsi
References: <1375951572-10829-1-git-send-email-b.brezillon@overkiz.com> <1375957837-11600-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375957837-11600-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 12:30, Boris BREZILLON :
> This patch removes the old main clk node which is now useless as sama5d3
> SoCs and boards are no longer compatible with the old at91 clk
> implementations.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

As said earlier, removal of old clock definitions is needed in this 
patch. You can even squash all this cleanup stuff in a single patch to 
remove all old material.

otherwise:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   arch/arm/boot/dts/sama5d3xcm.dtsi |   11 -----------
>   1 file changed, 11 deletions(-)
>
> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
> index f19d5bf..81c3957 100644
> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
> @@ -18,17 +18,6 @@
>   		reg = <0x20000000 0x20000000>;
>   	};
>
> -	clocks {
> -		#address-cells = <1>;
> -		#size-cells = <1>;
> -		ranges;
> -
> -		main_clock: clock@0 {
> -			compatible = "atmel,osc", "fixed-clock";
> -			clock-frequency = <12000000>;
> -		};
> -	};
> -
>   	ahb {
>   		apb {
>   			spi0: spi@f0004000 {
>


-- 
Nicolas Ferre
