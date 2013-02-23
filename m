Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3BWF2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 00:28:32 -0500
Received: from f2.mail.ru ([217.69.129.64]:60353 "EHLO f2.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab3BWF2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 00:28:31 -0500
X-Greylist: delayed 1051 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2013 00:28:31 EST
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?U3RlcGhlbiBXYXJyZW4=?= <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?B?VGhpZXJyeSBSZWRpbmc=?= <thierry.reding@avionic-design.de>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2NSAxLzNdIG1mZDogc3lzY29uOiBSZW1vdmVkIHN1?=
 =?UTF-8?B?cHBvcnQgZm9yIHVubG9hZGluZw==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sat, 23 Feb 2013 09:28:28 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361597308.137178281@f2.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <512851E0.7000808@wwwdotorg.org>
References: <1361596520-19332-1-git-send-email-shc_work@mail.ru> <512851E0.7000808@wwwdotorg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1N5SY4H019065

> On 02/22/2013 10:15 PM, Alexander Shiyan wrote:
> > The driver can be used in various subsystems and therefore should not
> > be unloaded when it is defined in the kernel configuration, so remove
> > support for unloading it.
> 
> Why not fix the clients to module_get() at the appropriate times; then
> you could still allow unloading, couldn't you?

I has explain this before. Driver defined as "bool" and loaded via postcore_initcall.
Once loaded it should not be unloaded, in other case it have not way to be loaded back.
I am correctly understand your question?
Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
