Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3LBIce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:32:34 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:22876 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3LBIcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:32:33 -0500
Message-ID: <529C4599.4030601@atmel.com>
Date: Mon, 2 Dec 2013 09:32:25 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: <plagnioj@jcrosoft.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] arm: at91: sama5d3: enable qt1070 as a wakeup source
References: <1385972988-20157-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1385972988-20157-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 09:29, Bo Shen :
> Enable qt1070 keyboard as a wakeup source on sama5d3xek board.
>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks,

> ---
>   arch/arm/boot/dts/sama5d3xdm.dtsi |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sama5d3xdm.dtsi
> index 1c296d6..f9bdde5 100644
> --- a/arch/arm/boot/dts/sama5d3xdm.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xdm.dtsi
> @@ -18,6 +18,7 @@
>   					interrupts = <31 0x0>;
>   					pinctrl-names = "default";
>   					pinctrl-0 = <&pinctrl_qt1070_irq>;
> +					wakeup-source;
>   				};
>   			};
>
>


-- 
Nicolas Ferre
