Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab3KSFIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:08:06 -0500
Received: from mail.active-venture.com ([67.228.131.205]:56722 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3KSFIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:08:01 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528AF22C.8060907@roeck-us.net>
Date: Mon, 18 Nov 2013 21:07:56 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Markus Mayer <markus.mayer@linaro.org>, Wim Van Sebroeck <wim@iguana.be>,
        Christian Daudt <bcm@fixthebug.org>
CC: Linaro Patches <patches@linaro.org>, Matt Porter <matt.porter@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] ARM: bcm281xx: watchdog configuration
References: <1384824250-16727-1-git-send-email-markus.mayer@linaro.org> <1384824250-16727-3-git-send-email-markus.mayer@linaro.org>
In-Reply-To: <1384824250-16727-3-git-send-email-markus.mayer@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 05:24 PM, Markus Mayer wrote:
> This commit enables the watchdog driver for the BCM281xx family of SoCs.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   arch/arm/configs/bcm_defconfig |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
> index 6e49310..8b98e11 100644
> --- a/arch/arm/configs/bcm_defconfig
> +++ b/arch/arm/configs/bcm_defconfig
> @@ -130,3 +130,6 @@ CONFIG_CRC_ITU_T=y
>   CONFIG_CRC7=y
>   CONFIG_XZ_DEC=y
>   CONFIG_AVERAGE=y
> +CONFIG_WATCHDOG=y
> +CONFIG_BCM_KONA_WDT=y
> +CONFIG_BCM_KONA_WDT_DEBUG=y
>

