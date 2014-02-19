Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaBSVVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:21:24 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:43216 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaBSVVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:21:23 -0500
Message-ID: <53052059.3020105@linaro.org>
Date: Wed, 19 Feb 2014 15:21:29 -0600
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matt Porter <mporter@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
CC: Christian Daudt <bcm@fixthebug.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>
Subject: Re: [PATCH] ARM: dts: remove bcm11351-brt.dts
References: <1392840808-28214-1-git-send-email-mporter@linaro.org>
In-Reply-To: <1392840808-28214-1-git-send-email-mporter@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 02:13 PM, Matt Porter wrote:
> The BCM11351 BRT board will never see the light of day. Remove the BRT
> dts since it is not maintainable.
> 
> Signed-off-by: Matt Porter <mporter@linaro.org>

Please remove the line in the Makefile that refers to this file.
Provided you make that change, it looks good to me.

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
>  arch/arm/boot/dts/bcm11351-brt.dts | 54 --------------------------------------
>  1 file changed, 54 deletions(-)
>  delete mode 100644 arch/arm/boot/dts/bcm11351-brt.dts
> 
> diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
> deleted file mode 100644
> index 396b704..0000000
> --- a/arch/arm/boot/dts/bcm11351-brt.dts
> +++ /dev/null
> @@ -1,54 +0,0 @@
> -/*
> - * Copyright (C) 2012 Broadcom Corporation
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> - * kind, whether express or implied; without even the implied warranty
> - * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -/dts-v1/;
> -
> -#include "bcm11351.dtsi"
> -
> -/ {
> -	model = "BCM11351 BRT board";
> -	compatible = "brcm,bcm11351-brt", "brcm,bcm11351";
> -
> -	memory {
> -		reg = <0x80000000 0x40000000>; /* 1 GB */
> -	};
> -
> -	uart@3e000000 {
> -		status = "okay";
> -	};
> -
> -	sdio1: sdio@3f180000 {
> -		max-frequency = <48000000>;
> -		status = "okay";
> -	};
> -
> -	sdio2: sdio@3f190000 {
> -		non-removable;
> -		max-frequency = <48000000>;
> -		status = "okay";
> -	};
> -
> -	sdio4: sdio@3f1b0000 {
> -		max-frequency = <48000000>;
> -		cd-gpios = <&gpio 14 0>;
> -		status = "okay";
> -	};
> -
> -	usbotg: usb@3f120000 {
> -		status = "okay";
> -	};
> -
> -	usbphy: usb-phy@3f130000 {
> -		status = "okay";
> -	};
> -};
> 

