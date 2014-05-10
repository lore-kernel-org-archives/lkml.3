Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbaEJO0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 10:26:06 -0400
Received: from f256.i.mail.ru ([94.100.178.221]:40085 "EHLO f256.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbaEJO0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 10:26:04 -0400
X-Greylist: delayed 15560 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 May 2014 10:26:04 EDT
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?Vml2ZWsgR2F1dGFt?= <gautam.vivek@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, swarren@wwwdotorg.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, stern@rowland.harvard.edu,
        linux-tegra@vger.kernel.org, thierry.reding@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAwLzZdIHVzYjogaG9zdDogQ2xlYW51cCBmb3IgaW9y?=
 =?UTF-8?B?ZW1hcCdpbmcgaGNkIG1lbW9yeQ==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Sat, 10 May 2014 18:25:56 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1399731956.962771892@f256.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com>
References: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4AEQMhV008924

Sat, 10 May 2014 17:30:04 +0530 Ğ¾Ñ‚ Vivek Gautam <gautam.vivek@samsung.com>:
> Based on 'usb-next' branch of Greg's usb tree.
> 
> devm_ioremap_resource() API is advantageous over devm_ioremap()
> and should therefore be preferred to request any ioremap'ed address
> for hcd.
> 
> Changes from v1:
>  - Changed the way returned pointer is checked for error value
>    as pointed out in the review comment in the mailing list.

hcd->rsrc_len field can be removed entirely, since I cannot find any reason
how this filed can be used in the drivers now.
This is of course should be in an another series. This one looks good.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
