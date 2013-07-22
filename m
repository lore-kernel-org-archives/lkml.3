Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab3GVWFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:05:10 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3111 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab3GVWFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:05:09 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51EDAC90.6010108@broadcom.com>
Date: Mon, 22 Jul 2013 15:05:04 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lee Jones" <lee.jones@linaro.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 06/22] ARM: dts: bcm281xx: Remove '0x's from
 BCM11351 DTS file
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1374490361-25769-6-git-send-email-lee.jones@linaro.org>
X-WSS-ID: 7DF375C32L851062288-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-07-22 03:52 AM, Lee Jones wrote:
> Cc: Christian Daudt <csd@broadcom.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/bcm11351.dtsi | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> index c0cdf66..db5873a 100644
> --- a/arch/arm/boot/dts/bcm11351.dtsi
> +++ b/arch/arm/boot/dts/bcm11351.dtsi
> @@ -34,7 +34,7 @@
>   		      <0x3ff00100 0x100>;
>   	};
>   
> -	smc@0x3404c000 {
> +	smc@3404c000 {
>   		compatible = "bcm,bcm11351-smc", "bcm,kona-smc";
>   		reg = <0x3404c000 0x400>; /* 1 KiB in SRAM */
>   	};
> @@ -63,28 +63,28 @@
>   		clock-frequency = <32768>;
>   	};
>   
> -	sdio0: sdio@0x3f180000 {
> +	sdio0: sdio@3f180000 {
>   		compatible = "bcm,kona-sdhci";
>   		reg = <0x3f180000 0x10000>;
>   		interrupts = <0x0 77 0x4>;
>   		status = "disabled";
>   	};
>   
> -	sdio1: sdio@0x3f190000 {
> +	sdio1: sdio@3f190000 {
>   		compatible = "bcm,kona-sdhci";
>   		reg = <0x3f190000 0x10000>;
>   		interrupts = <0x0 76 0x4>;
>   		status = "disabled";
>   	};
>   
> -	sdio2: sdio@0x3f1a0000 {
> +	sdio2: sdio@3f1a0000 {
>   		compatible = "bcm,kona-sdhci";
>   		reg = <0x3f1a0000 0x10000>;
>   		interrupts = <0x0 74 0x4>;
>   		status = "disabled";
>   	};
>   
> -	sdio3: sdio@0x3f1b0000 {
> +	sdio3: sdio@3f1b0000 {
>   		compatible = "bcm,kona-sdhci";
>   		reg = <0x3f1b0000 0x10000>;
>   		interrupts = <0x0 73 0x4>;
Acked-by: Christian Daudt <csd@broadcom.com>

  Thanks,
    csd

