Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3LBLPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:15:19 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:35886 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3LBLPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:15:16 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>
Cc: =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWljaGFlbCBHcnplc2NoaWs=?= <mgr@pengutronix.de>,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBSRVNFTkRdIG1mZDogbWMxM3h4eDogRml4IG51bGwgcG9p?=
 =?UTF-8?B?bnRlciBkZXJlZmVyZW5jZSBpbiBtYzEzeHh4X2NvbW1vbl9pbml0?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Mon, 02 Dec 2013 15:11:03 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1385982663.209903201@f198.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20131202105650.GD29373@lee--X1>
References: <1385787337-5296-1-git-send-email-shc_work@mail.ru>
 <1385805125.304293643@f433.i.mail.ru>
 <20131202105650.GD29373@lee--X1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB2BFQB1012346




ĞŸĞ¾Ğ½ĞµĞ´ĞµĞ»ÑŒĞ½Ğ¸Ğº,  2 Ğ´ĞµĞºĞ°Ğ±Ñ€Ñ 2013, 10:56 UTC Ğ¾Ñ‚ Lee Jones <lee.jones@linaro.org>:
> On Sat, 30 Nov 2013, Alexander Shiyan wrote:
> 
> > > On Sat, Nov 30, 2013 at 08:55:37AM +0400, Alexander Shiyan wrote:
> > > > If this driver being loaded from devicetree, the pdata is NULL.
> > > > This cause kernel Oops when "fsl,mc13xxx-uses-codec" and/or
> > > > "fsl,mc13xxx-uses-touch" properties is specified.
> > > > 
> > > > mc13xxx spi0.0: mc13783: rev: 3.3, fin: 0, fab: 0, icid: 2/0
> > > > Unable to handle kernel NULL pointer dereference at virtual address 00000018
> > ...
> > > > -	if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
> > > > +	if ((mc13xxx->flags & MC13XXX_USE_CODEC) && pdata)
> > > 
> > > Why do we check for CODEC if the Touchscreen should be used?
> > 
> > Oops, my fault, copy/paste bug.
> > I'll send the corrected version.
> 
> No, please don't.
> 
> Just provide proper Device Tree support.

I still have two incomplete MC13XXX DT-related patches.
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/175099.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/182116.html

I'll resume to work on this (and CODEC & TS too).
Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
