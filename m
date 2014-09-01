Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaIAJmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:42:40 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19169 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaIAJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:42:39 -0400
Message-ID: <54043F8C.8070307@atmel.com>
Date: Mon, 1 Sep 2014 11:42:36 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] dtb: at91: sam9n12ek: ohci: add port and vbus property
References: <1409133169-26741-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1409133169-26741-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2014 11:52, Bo Shen :
> Add the port number and vbus property for ohci port, or else if
> bootloader won't configure the vbus pin, the 5v supply is not
> power on, so can not work with usb devices.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Ok, thanks:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> 
>  arch/arm/boot/dts/at91sam9n12ek.dts | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
> index 83d7237..13bb24e 100644
> --- a/arch/arm/boot/dts/at91sam9n12ek.dts
> +++ b/arch/arm/boot/dts/at91sam9n12ek.dts
> @@ -136,6 +136,8 @@
>  		};
>  
>  		usb0: ohci@00500000 {
> +			num-ports = <1>;
> +			atmel,vbus-gpio = <&pioB 7 GPIO_ACTIVE_LOW>;
>  			status = "okay";
>  		};
>  	};
> 


-- 
Nicolas Ferre
