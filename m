Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaDRUuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:50:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:25451 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaDRUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:49:56 -0400
Message-ID: <53518FEE.9090207@atmel.com>
Date: Fri, 18 Apr 2014 22:49:50 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@kernel.org>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] ARM: at91: sama5d3: correct the sound compatible
 string
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-4-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1395049541-28128-4-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/2014 10:45, Bo Shen :
> As the sama5d3 dtsi file in go into mainline before sound driver,
> and, the sound compatible string is changed when go into mainline.
> Add this patch to correct the sound compatible string.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> 
>  arch/arm/boot/dts/sama5d3xmb.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 2938605..e1bd5767 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -156,7 +156,7 @@
>  	};
>  
>  	sound {
> -		compatible = "atmel,sama5d3ek-wm8904";
> +		compatible = "atmel,asoc-wm8904";
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&pinctrl_pck0_as_audio_mck>;
>  
> 


-- 
Nicolas Ferre
