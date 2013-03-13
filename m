Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab3CMSne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:43:34 -0400
Received: from f299.mail.ru ([217.69.129.81]:54422 "EHLO f299.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab3CMSnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:43:33 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?U3RlcGhlbiBXYXJyZW4=?= <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?B?VGhpZXJyeSBSZWRpbmc=?= <thierry.reding@avionic-design.de>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2NyAyLzJdIG1mZDogc3lzY29uOiBBZGQgbm9uLURU?=
 =?UTF-8?B?IHN1cHBvcnQ=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Wed, 13 Mar 2013 22:43:28 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1363200208.124789915@f299.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <5140C65C.3040705@wwwdotorg.org>
References: <1363196060-1149-1-git-send-email-shc_work@mail.ru> <1363196060-1149-2-git-send-email-shc_work@mail.ru> <5140C65C.3040705@wwwdotorg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2DIhXrr025108

> On 03/13/2013 11:34 AM, Alexander Shiyan wrote:
> > This patch allow using syscon driver from the platform data, i.e.
> > possibility using driver on systems without oftree support.
> > For search syscon device from the client drivers,
> > "syscon_regmap_lookup_by_pdevname" function was added.
> 
> This patch also removes the driver's remove() function, which isn't
> mentioned in the commit description.

Driver is using resource managed functions, remove() is not necessary.

> Otherwise I didn't see any issues at a quick glance.
 

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
