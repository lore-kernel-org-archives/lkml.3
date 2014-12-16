Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaLPKeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:34:01 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:53697 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaLPKd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:33:59 -0500
Message-ID: <54900A94.1080001@atmel.com>
Date: Tue, 16 Dec 2014 11:33:56 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: sama5d4: fix the timer reg length
References: <1418266473-30187-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1418266473-30187-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/12/2014 03:54, Bo Shen a écrit :
> The second property of reg is the length, so correct it for timer.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and stacked on top of at91-3.19-fixes.

Thanks.

> ---
> 
>  arch/arm/boot/dts/sama5d4.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
> index 2cc3cfe..0901706 100644
> --- a/arch/arm/boot/dts/sama5d4.dtsi
> +++ b/arch/arm/boot/dts/sama5d4.dtsi
> @@ -940,7 +940,7 @@
>  
>  			pit: timer@fc068630 {
>  				compatible = "atmel,at91sam9260-pit";
> -				reg = <0xfc068630 0xf>;
> +				reg = <0xfc068630 0x10>;
>  				interrupts = <3 IRQ_TYPE_LEVEL_HIGH 5>;
>  				clocks = <&h32ck>;
>  			};
> 


-- 
Nicolas Ferre
