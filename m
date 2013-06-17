Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3FQG1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:27:04 -0400
Received: from fallback4.mail.ru ([94.100.176.42]:37101 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3FQG1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:27:02 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?U3RlcGhlbiBSb3Rod2VsbA==?= <sfr@canb.auug.org.au>
Cc: =?UTF-8?B?QnJ5YW4gV3U=?= <cooloney@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IGxpbnV4LW5leHQ6IGJ1aWxkIGZhaWx1cmUgYWZ0ZXIgbWVyZ2Ugb2Yg?=
 =?UTF-8?B?dGhlIGxlZHMgdHJlZQ==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Mon, 17 Jun 2013 10:26:31 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1371450391.658890225@f333.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130617152908.1b9c999c01f18262a387dc91@canb.auug.org.au>
References: <20130617152908.1b9c999c01f18262a387dc91@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5H6RUQb018322

> Hi Bryan,
> 
> After merging the leds tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/leds/leds-mc13783.c: In function 'mc13xxx_led_probe':
> drivers/leds/leds-mc13783.c:280:4: error: implicit declaration of function 'of_get_next_child' [-Werror=implicit-function-declaration]
>     child = of_get_next_child(parent, child);
>     ^
> 
> Caused by commit 2ca3a455432f ("leds: leds-mc13783: Add devicetree support").  of_get_next_child() is only defined if CONFIG_OF is set.
> 
> I have used the version of the leds tree from next-20130607 for today.

The patch has already been sent by me.
http://www.spinics.net/lists/linux-leds/msg00994.html

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
