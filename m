Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab3GVWDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:03:46 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3719 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab3GVWDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:03:45 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <51EDAC37.80305@broadcom.com>
Date: Mon, 22 Jul 2013 15:03:35 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lee Jones" <lee.jones@linaro.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 05/22] ARM: dts: bcm281xx: Remove '0x's from
 BCM11351 BRT DTS file
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-5-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1374490361-25769-5-git-send-email-lee.jones@linaro.org>
X-WSS-ID: 7DF375471R046851205-01-01
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
>   arch/arm/boot/dts/bcm11351-brt.dts | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
> index 67ec524..fdace5d 100644
> --- a/arch/arm/boot/dts/bcm11351-brt.dts
> +++ b/arch/arm/boot/dts/bcm11351-brt.dts
> @@ -27,18 +27,18 @@
>   		status = "okay";
>   	};
>   
> -	sdio0: sdio@0x3f180000 {
> +	sdio0: sdio@3f180000 {
>   		max-frequency = <48000000>;
>   		status = "okay";
>   	};
>   
> -	sdio1: sdio@0x3f190000 {
> +	sdio1: sdio@3f190000 {
>   		non-removable;
>   		max-frequency = <48000000>;
>   		status = "okay";
>   	};
>   
> -	sdio3: sdio@0x3f1b0000 {
> +	sdio3: sdio@3f1b0000 {
>   		max-frequency = <48000000>;
>   		status = "okay";
>   	};
Acked-by: Christian Daudt <csd@broadcom.com>

  Thanks,
    csd


