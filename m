Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbaAHUDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:03:30 -0500
Received: from f123.i.mail.ru ([94.100.178.187]:49533 "EHLO f123.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaAHUD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:03:27 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?Sm9obiBUb2JpYXM=?= <john.tobias.ph@gmail.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gQVJNOiBpbXg6IGFkZCBzZWxlY3Qgb24gQVJDSF9N?=
 =?UTF-8?B?WEMgZm9yIGNwdWZyZXEgc3VwcG9ydA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Thu, 09 Jan 2014 00:03:23 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1389211403.678513817@f123.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1389210991-23688-1-git-send-email-john.tobias.ph@gmail.com>
References: <1389210991-23688-1-git-send-email-john.tobias.ph@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s08K3Y8c029202

Hello.

Ğ¡Ñ€ĞµĞ´Ğ°,  8 ÑĞ½Ğ²Ğ°Ñ€Ñ 2014, 11:56 -08:00 Ğ¾Ñ‚ John Tobias <john.tobias.ph@gmail.com>:
> Moved ARCH_HAS_CPUFREQ, HAVE_IMX_ANATOP and PM_OPP on ARCH_MXC so that
> the user can enable the cpufreq support for iMX6Q and/or iMX6SL.
> 
> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
> ---
>  arch/arm/mach-imx/Kconfig | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 7a6e6f7..3c326be 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -1,5 +1,6 @@
>  config ARCH_MXC
>  	bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
> +	select ARCH_HAS_CPUFREQ
>  	select ARCH_REQUIRE_GPIOLIB
>  	select ARM_CPU_SUSPEND if PM
>  	select ARM_PATCH_PHYS_VIRT
> @@ -9,8 +10,10 @@ config ARCH_MXC
>  	select GENERIC_ALLOCATOR
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_IRQ_CHIP
> +	select HAVE_IMX_ANATOP

Maybe better:
select HAVE_IMX_ANATOP if ARCH_MULTI_V6_V7

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
