Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaAQTYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:24:50 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:38290 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaAQTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:24:47 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWFyYyBDYXJpbm8=?= <marc.ceeeee@gmail.com>
Cc: =?UTF-8?B?Q2hyaXN0aWFuIERhdWR0?= <bcm@fixthebug.org>,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        devicetree@vger.kernel.org,
        =?UTF-8?B?RmxvcmlhbiBGYWluZWxsaQ==?= <f.fainelli@gmail.com>,
        =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWF0dCBQb3J0ZXI=?= <matt.porter@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NCAzLzhdIEFSTTogYnJjbXN0YjogYWRkIGRlYnVnIFVB?=
 =?UTF-8?B?UlQgZm9yIGVhcmx5cHJpbnRrIHN1cHBvcnQ=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Fri, 17 Jan 2014 23:24:16 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1389986656.910825095@f427.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1389986367-4010-4-git-send-email-marc.ceeeee@gmail.com>
References: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com>
 <1389986367-4010-4-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HJOwN0027153

ĞŸÑÑ‚Ğ½Ğ¸Ñ†Ğ°, 17 ÑĞ½Ğ²Ğ°Ñ€Ñ 2014, 11:19 -08:00 Ğ¾Ñ‚ Marc Carino <marc.ceeeee@gmail.com>:
> Add the UART definitions needed to support earlyprintk on brcmstb machines.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  arch/arm/Kconfig.debug |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 5765abf..266c699 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -94,6 +94,17 @@ choice
>  		depends on ARCH_BCM2835
>  		select DEBUG_UART_PL01X
>  
> +	config DEBUG_BRCMSTB_UART
> +		bool "Use BRCMSTB UART for low-level debug"
> +		depends on ARCH_BRCMSTB
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want the debug print routines to direct
> +		  their output to the first serial port on these devices.
> +
> +		  If you have a Broadcom STB chip and would like early print
> +		  messages to appear over the UART, select this option.
> +
>  	config DEBUG_CLPS711X_UART1
>  		bool "Kernel low-level debugging messages via UART1"
>  		depends on ARCH_CLPS711X
> @@ -988,6 +999,7 @@ config DEBUG_UART_PHYS
>  	default 0x20064000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
>  	default 0x20068000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
>  	default 0x20201000 if DEBUG_BCM2835
> +	default 0xf0406b00 if DEBUG_BRCMSTB_UART

This should be sorted by address.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
