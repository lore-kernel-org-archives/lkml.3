Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3LTT4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:56:06 -0500
Received: from fallback1.mail.ru ([94.100.176.18]:50571 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3LTT4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:56:04 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Um9iIEhlcnJpbmc=?= <robh@kernel.org>,
        =?UTF-8?B?TWlrZSBUdXJxdWV0dGU=?= <mturquette@linaro.org>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@kernel.org>,
        =?UTF-8?B?RGFuaWVsIExlemNhbm8=?= <daniel.lezcano@linaro.org>,
        arm@kernel.org, kernel@pengutronix.de,
        =?UTF-8?B?R3JhbnQgTGlrZWx5?= <grant.likely@linaro.org>,
        =?UTF-8?B?VGhvbWFzIEdsZWl4bmVy?= <tglx@linutronix.de>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gTUFJTlRBSU5FUlM6IHRha2UgbWFpbnRhaW5lcnNoaXAg?=
 =?UTF-8?B?Zm9yIEVuZXJneSBNaWNybyBlZm0zMiBTb0Nz?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Fri, 20 Dec 2013 23:55:30 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1387569330.616105313@f421.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1387568343-8754-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1387568343-8754-1-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBKJuAOe015755

> Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>
...
> I think this can best go in via armsoc, but needs acks for clk, clocksource,
> spi and tty/serial.
...
>  MAINTAINERS | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 95648eb..28c69a6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -867,6 +867,21 @@ S:	Maintained
>  F:	arch/arm/mach-ebsa110/
>  F:	drivers/net/ethernet/amd/am79c961a.*
>  
> +ARM/ENERGY MICRO (SILICON LABS) EFM32 SUPPORT
> +M:	Uwe Kleine-KÃ¶nig <kernel@pengutronix.de>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	arch/arm/boot/dts/efm32*
> +F:	arch/arm/configs/efm32_defconfig
> +F:	arch/arm/include/debug/efm32.S
> +F:	arch/arm/mach-efm32/
> +F:	drivers/clk/clk-efm32gg.c
> +F:	drivers/clocksource/time-efm32.c
> +F:	drivers/spi/spi-efm32.c
> +F:	drivers/tty/serial/efm32-uart.c
> +F:	include/dt-bindings/clock/efm32-cmu.h
> +F:	include/linux/platform_data/efm32-*

Maybe "N" keyword with "efm32" is better here?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
