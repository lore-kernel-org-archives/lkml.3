Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3HWT1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:27:07 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:34603 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3HWT1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:27:05 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?Vml2aWVuIERpZGVsb3Q=?= 
	<vivien.didelot@savoirfairelinux.com>
Cc: =?UTF-8?B?V29sZnJhbSBTYW5n?= <wsa@the-dreams.de>,
        kernel@savoirfairelinux.com, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbWlzYzogKGF0MjQpIG1vdmUgaGVhZGVyIHRvIGxpbnV4?=
 =?UTF-8?B?L3BsYXRmb3JtX2RhdGEv?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Fri, 23 Aug 2013 23:26:36 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1377285996.620418788@f48.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <1033284781.908504.1377285587778.JavaMail.root@mail>
References: <20130823190247.GA3821@katana>
 <1033284781.908504.1377285587778.JavaMail.root@mail>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7NJRB96009736

> Wolfram wrote:
> 
> > On Fri, Aug 23, 2013 at 02:38:20PM -0400, Vivien Didelot wrote:
> > > This patch moves the at24.h header from include/linux/i2c to
> > > include/linux/platform_data and updates existing support
> > > accordingly.
> > 
> > This message explains what the patch does but not why the change is
> > wanted. I'd be surprised if we really want *all* platform_data in one
> > single directory?
> 
> IMHO it makes sense. Why wouldn't we want all platform_data in
> include/linux/platform_data/?

Can this file be additionally renamed to misc-at24.h to reflect belongs
to a particular subsystem?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
