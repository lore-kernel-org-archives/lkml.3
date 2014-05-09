Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaEIN4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:56:37 -0400
Received: from fallback4.mail.ru ([94.100.176.42]:33292 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaEIN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:56:35 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TGlhbSBHaXJkd29vZA==?= <lgirdwood@gmail.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@kernel.org>,
        =?UTF-8?B?SmFyb3NsYXYgS3lzZWxh?= <perex@perex.cz>,
        =?UTF-8?B?VGFrYXNoaSBJd2Fp?= <tiwai@suse.de>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzJdIG1mZDogbWMxM3h4eDogRG8gbm90IHVzZSBwbGF0?=
 =?UTF-8?B?Zm9ybSBkYXRhIHdpdGggZGV2aWNldHJlZQ==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Fri, 09 May 2014 17:56:09 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1399643769.716496780@f345.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140509113030.GV5767@lee--X1>
References: <1398926883-21778-1-git-send-email-shc_work@mail.ru>
 <20140509113030.GV5767@lee--X1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s49DufpJ003515

Fri, 9 May 2014 12:30:30 +0100 Ğ¾Ñ‚ Lee Jones <lee.jones@linaro.org>:
> > This patch removes platform data usage for codec and touchscreen
> > when driver is used with devicetree.
> > This fixes possible "null pointer dereference" error if DTS uses
> > "fsl,mc13xxx-uses-codec" or "fsl,mc13xxx-uses-touch" options.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/mfd/mc13xxx-core.c | 18 ++++++++++--------
> >  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> Applied, thanks.

This patch has been written as a way to separate MFD and ASoC changes of
the patch: (ASoC: mc13783: Add devicetree support)
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=780aaeff96819ca58e0cad830bfbe6eee9aef82c

So, it should produce conflict.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
