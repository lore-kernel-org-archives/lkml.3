Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3DHEp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:45:58 -0400
Received: from f36.mail.ru ([217.69.128.193]:37056 "EHLO f36.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab3DHEp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:45:57 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?U3RlcGhlbiBSb3Rod2VsbA==?= <sfr@canb.auug.org.au>
Cc: =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IGxpbnV4LW5leHQ6IGJ1aWxkIGZhaWx1cmUgYWZ0ZXIgbWVyZ2Ugb2Yg?=
 =?UTF-8?B?dGhlIG1mZCB0cmVl?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Mon, 08 Apr 2013 08:45:51 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1365396351.542317232@f36.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
References: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r384juew022868

Hello.

> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
> drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]
> 
> Caused by commit 5ab3a89a741f ("mfd: syscon: Add non-DT support").
> 
> I have used the mfd tree from next-20130405 for today.

This means that we do not have empty declarations for the
of_xx functions in linux/of.h for !CONFIG_OF.
OK to declare these functions or any other opinions?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
