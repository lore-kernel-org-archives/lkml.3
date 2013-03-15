Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3COE0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:26:38 -0400
Received: from f228.mail.ru ([94.100.178.214]:35086 "EHLO f228.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab3COE0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:26:35 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?B?VGhpZXJyeSBSZWRpbmc=?= <thierry.reding@avionic-design.de>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?U3RlcGhlbiBXYXJyZW4=?= <swarren@wwwdotorg.org>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2NyAyLzJdIG1mZDogc3lzY29uOiBBZGQgbm9uLURU?=
 =?UTF-8?B?IHN1cHBvcnQ=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Fri, 15 Mar 2013 08:26:30 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1363321590.65573886@f228.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
References: <1363196060-1149-1-git-send-email-shc_work@mail.ru> <1363196060-1149-2-git-send-email-shc_work@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2F4QmhL002395

> On 14 March 2013 01:34, Alexander Shiyan <shc_work@mail.ru> wrote:
> > This patch allow using syscon driver from the platform data, i.e.
> > possibility using driver on systems without oftree support.
> > For search syscon device from the client drivers,
> > "syscon_regmap_lookup_by_pdevname" function was added.
> >
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> 
> Actually i've acked this series before, usually you can send out the
> updated series
> with my tag if no other big changes except the minor comments fix i pointed out.
> Here again, for this series:
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
...

There remains only one question. Who can commit the patch to the kernel...

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
