Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965670Ab3FTVOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:14:25 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2825 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965398Ab3FTVOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:14:24 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <51C370A5.3020900@broadcom.com>
Date: Thu, 20 Jun 2013 14:14:13 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Matt Porter" <matt.porter@linaro.org>
cc: "Arnd Bergmann" <arnd@arndb.de>, "Olof Johansson" <olof@lixom.net>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linaro Patches" <patches@linaro.org>
Subject: Re: [PATCH] ARM: dts: bcm281xx: change comment to C89 style
References: <1370976358-18014-1-git-send-email-matt.porter@linaro.org>
In-Reply-To: <1370976358-18014-1-git-send-email-matt.porter@linaro.org>
X-WSS-ID: 7DDDB0C61R034567675-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-11 11:45 AM, Matt Porter wrote:
> CodingStyle does not allow C99 style comments. Since the
> dts files live in the kernel for now, make this compliant.
>
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> Acked-by: Christian Daudt <csd@broadcom.com>
> ---
>   arch/arm/boot/dts/bcm11351.dtsi |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> index 824bebe..0651a72 100644
> --- a/arch/arm/boot/dts/bcm11351.dtsi
> +++ b/arch/arm/boot/dts/bcm11351.dtsi
> @@ -36,7 +36,7 @@
>   
>   	smc@0x3404c000 {
>   		compatible = "bcm,bcm11351-smc", "bcm,kona-smc";
> -		reg = <0x3404c000 0x400>; //1 KiB in SRAM
> +		reg = <0x3404c000 0x400>; /* 1 KiB in SRAM */
>   	};
>   
>   	uart@3e000000 {
applied for for-3.11/dt
  thanks,
    csd


