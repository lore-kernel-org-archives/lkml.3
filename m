Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaELFDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 01:03:30 -0400
Received: from f188.i.mail.ru ([94.100.185.40]:34409 "EHLO f188.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaELFD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 01:03:29 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?U2FzY2hhIEhhdWVy?= <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?TGludXMgV2FsbGVpag==?= <linus.walleij@linaro.org>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@linaro.org>,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gcGluY3RybDogQWRkIGkuTVgxIHBpbmNvbnRyb2wgZHJp?=
 =?UTF-8?B?dmVy?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Mon, 12 May 2014 09:03:26 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1399871006.529846706@f188.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140512045113.GY5858@pengutronix.de>
References: <1399652193-17827-1-git-send-email-shc_work@mail.ru>
 <20140512045113.GY5858@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4C53Z4M016976

Mon, 12 May 2014 06:51:13 +0200 Ğ¾Ñ‚ Sascha Hauer <s.hauer@pengutronix.de>:
> On Fri, May 09, 2014 at 08:16:33PM +0400, Alexander Shiyan wrote:
> > This patch adds pincontrol driver for Freescale i.MX1 SOCs.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/pinctrl/Kconfig        |   7 ++
> >  drivers/pinctrl/Makefile       |   1 +
> >  drivers/pinctrl/pinctrl-imx1.c | 279 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 287 insertions(+)
> >  create mode 100644 drivers/pinctrl/pinctrl-imx1.c
> 
> Nice. I thought about adding devicetree support for i.MX1 aswell.
> 
> Don't we need a imx1-pinfunc.h file to make use of this patch?

It will be added along with the DTS template for that CPU architecture.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
