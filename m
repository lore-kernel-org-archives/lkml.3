Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaFXJl1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 24 Jun 2014 05:41:27 -0400
Received: from fallback8.mail.ru ([94.100.181.110]:54621 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFXJl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:41:26 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@freescale.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbWZkOiBtYzEzeHh4OiBVc2UgcmVnbWFwIGlycSBm?=
 =?UTF-8?B?cmFtZXdvcmsgZm9yIGludGVycnVwdHM=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Tue, 24 Jun 2014 13:37:31 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1403602651.181294577@f348.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140624092922.GE13803@lee--X1>
References: <1403111140-17056-1-git-send-email-shc_work@mail.ru>
 <20140624092922.GE13803@lee--X1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s5O9famC007950

Tue, 24 Jun 2014 10:29:22 +0100 Ğ¾Ñ‚ Lee Jones <lee.jones@linaro.org>:
> > This patch convert mc13xxx MFD driver to use regmap irq framework
> > for interrupt registration.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> It's helpful if you add a v1 -> v2 changelog here, so we can keep up
> with what's happening.

Yes, the basic changes are:
- Use disable_irq_nosync() instead of disable_irq() due to usage this callback in the ISR.
- Remove IRQF_ONESHOT flag from slave IRQs.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
