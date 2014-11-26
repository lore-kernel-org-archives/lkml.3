Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaKZDOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 22:14:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:59061 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaKZDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 22:14:34 -0500
Message-ID: <5475456C.509@atmel.com>
Date: Wed, 26 Nov 2014 11:13:48 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Boris Brezillon <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/3] ARM: at91: sama5d4: Add SFR
References: <1416933604-31446-1-git-send-email-alexandre.belloni@free-electrons.com> <1416933604-31446-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1416933604-31446-3-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alexandre

On 11/26/2014 12:40 AM, Alexandre Belloni wrote:
> The sama4d4 has Special Function Registers that allow to manage DDR, OHCI, EBI
> and AIC interrupt redirection.

Just a nitpick, It should be sama5d4, not sama4d4.

Best Regards,
Josh Wu

>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>   arch/arm/boot/dts/sama5d4.dtsi | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
> index e0157b0f075c..9e281e22d591 100644
> --- a/arch/arm/boot/dts/sama5d4.dtsi
> +++ b/arch/arm/boot/dts/sama5d4.dtsi
> @@ -826,6 +826,11 @@
>   				status = "disabled";
>   			};
>   
> +			sfr: sfr@f8028000 {
> +				compatible = "atmel,sama5d4-sfr", "syscon";
> +				reg = <0xf8028000 0x4000>;
> +			};
> +
>   			mmc1: mmc@fc000000 {
>   				compatible = "atmel,hsmci";
>   				reg = <0xfc000000 0x600>;

