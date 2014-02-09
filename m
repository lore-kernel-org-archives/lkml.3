Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaBIS51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:57:27 -0500
Received: from f148.i.mail.ru ([94.100.178.199]:40331 "EHLO f148.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaBIS50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:57:26 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UmljaGFyZCBXZWluYmVyZ2Vy?= <richard@nod.at>
Cc: =?UTF-8?B?Q2hyaXN0aWFuIERhdWR0?= <bcm@fixthebug.org>,
        =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxMi8yOF0gUmVtb3ZlIEdFTkVSSUNfVElNRQ==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sun, 09 Feb 2014 22:57:19 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1391972239.567717844@f148.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1391971686-9517-13-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-13-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s19IvWdn025463

> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
> arch/arm/mach-bcm/Kconfig | 1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> index b1aa6a9..8dd5fbf 100644
> --- a/arch/arm/mach-bcm/Kconfig
> +++ b/arch/arm/mach-bcm/Kconfig
> @@ -19,7 +19,6 @@ config ARCH_BCM_MOBILE
> select CPU_V7
> select CLKSRC_OF
> select GENERIC_CLOCKEVENTS
> -	select GENERIC_TIME
> select GPIO_BCM_KONA
> select SPARSE_IRQ
> select TICK_ONESHOT
> -- 
> 1.8.4.2

I sent a similar patch in November, maintainers nothing did with it.
http://permalink.gmane.org/gmane.linux.ports.arm.kernel/278293

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
