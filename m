Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbaFRDbZ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 17 Jun 2014 23:31:25 -0400
Received: from f152.i.mail.ru ([94.100.178.201]:50149 "EHLO f152.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933616AbaFRDbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:31:24 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@freescale.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbWZkOiBtYzEzeHh4OiBVc2UgcmVnbWFwIGlycSBmcmFt?=
 =?UTF-8?B?ZXdvcmsgZm9yIGludGVycnVwdHM=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.7]
Date: Wed, 18 Jun 2014 07:31:19 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1403062279.528598806@f152.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140617200459.GU29841@lee--X1>
References: <1402122010-28843-1-git-send-email-shc_work@mail.ru>
 <20140617200459.GU29841@lee--X1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s5I3VY2c028745

Tue, 17 Jun 2014 21:04:59 +0100 Ğ¾Ñ‚ Lee Jones <lee.jones@linaro.org>:
> On Sat, 07 Jun 2014, Alexander Shiyan wrote:
> 
> > This patch convert mc13xxx MFD driver to use regmap irq framework
> > for interrupt registration.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/mfd/Kconfig         |   1 +
> >  drivers/mfd/mc13xxx-core.c  | 299 ++++++--------------------------------------
> >  drivers/mfd/mc13xxx.h       |   7 +-
> >  include/linux/mfd/mc13xxx.h |  21 +++-
> >  4 files changed, 59 insertions(+), 269 deletions(-)
> 
> Patch looks good to me and I love the diffstat.  If any problems occur
> as a result of applying this patch we can fix it up as subsequent
> patch submissions.

Unfortunately, prolonged use of the modified version, revealed two errors.
I will try to make incremental patch quickly, or can send a second version
of the patch.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
