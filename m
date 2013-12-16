Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3LPVCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:02:32 -0500
Received: from f210.i.mail.ru ([94.100.178.205]:51788 "EHLO f210.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab3LPVC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:02:29 -0500
X-Greylist: delayed 42882 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 16:02:29 EST
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gcmVnbWFwOiBpcnE6IEFsbG93IHVzaW5nIHplcm8gdmFs?=
 =?UTF-8?B?dWUgZm9yIGFja19iYXNl?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Tue, 17 Dec 2013 01:02:26 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1387227746.558174684@f210.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20131216205020.GY3185@sirena.org.uk>
References: <1387100211-19101-1-git-send-email-shc_work@mail.ru>
 <20131216205020.GY3185@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBGL2dw6028373

> On Sun, Dec 15, 2013 at 01:36:51PM +0400, Alexander Shiyan wrote:
> > In some cases, clear interrupt register may be at address 0.
> > This patch allows to use such configurations by adding additional
> > configuration bit to indicate this.
> 
> Applied, thanks with the grammar for the docs corrected.  We probably ought to do this for most of the fields :/
> I guess this is for some driver you're upstreaming so a signed tag would
> be useful?  

I plan to use regmap-irq for migration mc13xxx MFD core to use IRQ domains.
It will not be so soon.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
