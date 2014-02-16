Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaBPTHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:07:01 -0500
Received: from f161.i.mail.ru ([94.100.178.81]:45180 "EHLO f161.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbaBPTHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:07:00 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UGF1bCBCb2xsZQ==?= <pebolle@tiscali.nl>
Cc: =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        =?UTF-8?B?UmljaGFyZCBXZWluYmVyZ2Vy?= <richard@nod.at>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gYXJtOiBpbXg6IHJlbW92ZSBNQUNIX01YTEFEUw==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sun, 16 Feb 2014 23:06:55 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1392577615.265469392@f161.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1392576223.28866.24.camel@x220>
References: <1392573811.28866.22.camel@x220>
 <1392574562.956803244@f244.i.mail.ru>
 <1392576223.28866.24.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1GJ79u6012761

Ğ’Ğ¾ÑĞºÑ€ĞµÑĞµĞ½ÑŒĞµ, 16 Ñ„ĞµĞ²Ñ€Ğ°Ğ»Ñ 2014, 19:43 +01:00 Ğ¾Ñ‚ Paul Bolle <pebolle@tiscali.nl>:
> On Sun, 2014-02-16 at 22:16 +0400, Alexander Shiyan wrote:
> > Ğ’Ğ¾ÑĞºÑ€ĞµÑĞµĞ½ÑŒĞµ, 16 Ñ„ĞµĞ²Ñ€Ğ°Ğ»Ñ 2014, 19:03 +01:00 Ğ¾Ñ‚ Paul Bolle
> <pebolle@tiscali.nl>:
> > > The Kconfig symbol MACH_MXLADS was added in v2.6.29. It has never been
> > > used. Setting it has no effect. There are no calls for
> > > machine_is_mxlads(). This symbol can safely be removed.
> > > 
> > > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > 
> > This is used by mach-mx1ads.c
> 
> How is it used?

Kconfig selects MACH_MXLADS, this enables machine_arch_type
from include/generated/mach-types.h which used for machine_is_xx() macro,
so if multiple boards is defined in the kernel, this cause to incorrect matching.
Russel, Arnd, fixme.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
