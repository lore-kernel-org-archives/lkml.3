Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3K3Jwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 04:52:37 -0500
Received: from fallback7.mail.ru ([94.100.176.135]:52017 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3K3Jwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 04:52:36 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWljaGFlbCBHcnplc2NoaWs=?= <mgr@pengutronix.de>
Cc: =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@linaro.org>,
        =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBSRVNFTkRdIG1mZDogbWMxM3h4eDogRml4IG51bGwgcG9p?=
 =?UTF-8?B?bnRlciBkZXJlZmVyZW5jZSBpbiBtYzEzeHh4X2NvbW1vbl9pbml0?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sat, 30 Nov 2013 13:52:05 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1385805125.304293643@f433.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20131130093456.GD28906@pengutronix.de>
References: <1385787337-5296-1-git-send-email-shc_work@mail.ru>
 <20131130093456.GD28906@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAU9qhIs004403

> On Sat, Nov 30, 2013 at 08:55:37AM +0400, Alexander Shiyan wrote:
> > If this driver being loaded from devicetree, the pdata is NULL.
> > This cause kernel Oops when "fsl,mc13xxx-uses-codec" and/or
> > "fsl,mc13xxx-uses-touch" properties is specified.
> > 
> > mc13xxx spi0.0: mc13783: rev: 3.3, fin: 0, fab: 0, icid: 2/0
> > Unable to handle kernel NULL pointer dereference at virtual address 00000018
...
> > -	if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
> > +	if ((mc13xxx->flags & MC13XXX_USE_CODEC) && pdata)
> 
> Why do we check for CODEC if the Touchscreen should be used?

Oops, my fault, copy/paste bug.
I'll send the corrected version.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
