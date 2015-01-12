Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbbALNWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:22:08 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:59403 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbALNWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:22:05 -0500
Message-ID: <54B3CA49.7010302@atmel.com>
Date: Mon, 12 Jan 2015 14:21:13 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: sama5d3: dt: correct the sound route
References: <1420795096-8944-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1420795096-8944-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/01/2015 10:18, Bo Shen a écrit :
> The MICBIAS is a supply, should route to MIC while not IN1L.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I stack it up in at91-3.19-fixes.

Thanks. Bye.


> ---
> 
>  arch/arm/boot/dts/sama5d3xmb.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 0399be6..83d0598 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -176,7 +176,7 @@
>  			"Headphone Jack", "HPOUTR",
>  			"IN2L", "Line In Jack",
>  			"IN2R", "Line In Jack",
> -			"MICBIAS", "IN1L",
> +			"Mic", "MICBIAS",
>  			"IN1L", "Mic";
>  
>  		atmel,ssc-controller = <&ssc0>;
> 


-- 
Nicolas Ferre
