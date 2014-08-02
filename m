Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaHBOIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 10:08:05 -0400
Received: from fallback5.mail.ru ([94.100.181.253]:37682 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaHBOID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 10:08:03 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?SGltYW5naSBTYXJhb2dp?= <himangi774@gmail.com>
Cc: julia.lawall@lip6.fr,
        =?UTF-8?B?TWFyYyBLbGVpbmUtQnVkZGU=?= <mkl@pengutronix.de>,
        =?UTF-8?B?T2xpdmVyIEhhcnRrb3Bw?= <socketcan@hartkopp.net>,
        =?UTF-8?B?U3RlZmFubyBCYWJpYw==?= <sbabic@denx.de>,
        =?UTF-8?B?SmluZ29vIEhhbg==?= <jg1.han@samsung.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIFBlbGxlZ3Jpbg==?= <chripell@fsfe.org>,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gY2FuOiBtY3AyNTF4OiBVc2UgZG1hbV9hbGxvY19jb2hl?=
 =?UTF-8?B?cmVudA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.7]
Date: Sat, 02 Aug 2014 18:07:30 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1406988450.383937334@f99.i.mail.ru>
X-Cloud-Ids: 
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140802135204.GA7635@himangi-Dell>
References: <20140802135204.GA7635@himangi-Dell>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s72E8JQv020635

Sat, 2 Aug 2014 19:22:04 +0530 Ğ¾Ñ‚ Himangi Saraogi <himangi774@gmail.com>:
> This patch moves the data allocated using dma_alloc_coherent to the
> corresponding managed interface and does away with the calls to free the
> allocated memory in the probe and remove functions.

Just for information: On my opinion, all SPI DMA stuff should be going into SPI layer.
It is not a good idea to keep this into this driver.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
