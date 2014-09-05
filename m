Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbaIEPVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:21:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:6555 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbaIEPVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:21:32 -0400
Message-ID: <5409D4F8.4090806@atmel.com>
Date: Fri, 5 Sep 2014 17:21:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?R2HDq2wgUE9SVEFZ?= <gael.portay@gmail.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: sam9g20: set at91sam9g20 pllb driver
References: <1409606986-32455-1-git-send-email-gael.portay@gmail.com>
In-Reply-To: <1409606986-32455-1-git-send-email-gael.portay@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 23:29, Gaël PORTAY :
> The at91sam9g20 SOC uses its own pllb implementation which is different
> from the one inherited from at91sam9260 SOC.
> 
> Signed-off-by: Gaël PORTAY <gael.portay@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Stacked on at91-3.17-fixes. Thanks!

> ---
>  arch/arm/boot/dts/at91sam9g20.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
> index 31f7652..4e0abbd 100644
> --- a/arch/arm/boot/dts/at91sam9g20.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g20.dtsi
> @@ -40,6 +40,7 @@
>  				};
>  
>  				pllb: pllbck {
> +					compatible = "atmel,at91sam9g20-clk-pllb";
>  					atmel,clk-input-range = <2000000 32000000>;
>  					atmel,pll-clk-output-ranges = <30000000 100000000 0 0>;
>  				};
> 


-- 
Nicolas Ferre
