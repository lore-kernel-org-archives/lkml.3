Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3BLGhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:37:47 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:44779 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3BLGhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:37:45 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2MiAxLzNdIG1mZDogc3lzY29uOiBSZW1vdmVkIHN1?=
 =?UTF-8?B?cHBvcnQgZm9yIHVubG9hZGluZw==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Tue, 12 Feb 2013 10:35:35 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1360650935.475602112@f368.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <201302112005.35034.arnd@arndb.de>
References: <1360608173-12907-1-git-send-email-shc_work@mail.ru> <201302112005.35034.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1C6bpbb020630

Hello.

> On Monday 11 February 2013, Alexander Shiyan wrote:
> > The driver can be used in various subsystems and therefore should not
> > be unloaded when it is defined in the kernel configuration, so remove
> > support for unloading it.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> 
> Can you describe a scenario where that would happen? Normally the
> module should stay pinned as long as any other module refers
> to its exported symbols.

Probably I wrote a bad description.
The driver registered by "postcore_initcall". Therefore, if we unregister the
driver, we have no way to register it back. Fixme please.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
