Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaDYUk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:40:28 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:49804 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbaDYUk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:40:26 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?R3JlZyBLSA==?= <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        =?UTF-8?B?Sm9uIFJpbmdsZQ==?= <jringle@gridpoint.com>, jon@ringle.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzJdIHNlcmlhbDogc2MxNmlzN3h4OiBkZXBlbmQgb24g?=
 =?UTF-8?B?STJD?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Sat, 26 Apr 2014 00:39:59 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1398458399.164274248@f343.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140425203528.GA15154@kroah.com>
References: <1398455590-4374-1-git-send-email-jon@ringle.org>
 <1398457576.792048107@f368.i.mail.ru>
 <20140425203528.GA15154@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3PKebWO010343

Fri, 25 Apr 2014 13:35:28 -0700 Ğ¾Ñ‚ Greg KH <gregkh@linuxfoundation.org>:
> On Sat, Apr 26, 2014 at 12:26:16AM +0400, Alexander Shiyan wrote:
> > Fri, 25 Apr 2014 13:23:15 -0700 Ğ¾Ñ‚ Greg KH <gregkh@linuxfoundation.org>:
> > > On Fri, Apr 25, 2014 at 03:53:09PM -0400, jon@ringle.org wrote:
> > > > From: Jon Ringle <jringle@gridpoint.com>
> > > > 
> > > > Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> > > > ---
> > > >  drivers/tty/serial/Kconfig | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> > > > index c3e2b32..64c5659 100644
> > > > --- a/drivers/tty/serial/Kconfig
> > > > +++ b/drivers/tty/serial/Kconfig
> > > > @@ -1180,6 +1180,7 @@ config SERIAL_SCCNXP_CONSOLE
> > > >  
> > > >  config SERIAL_SC16IS7XX
> > > >  	tristate "SC16IS7xx serial support"
> > > > +	depends on I2C
> > > >  	select SERIAL_CORE
> > > >  	select REGMAP_I2C if I2C
> > > >  	help
> > > > -- 
> > > > 1.8.5.4
> > > 
> > > Better, but I still have the build warnings :(
> > 
> > I hope not same as before?
> 
> Exactly the same.

Hmm...

In the source:
#ifdef CONFIG_REGMAP_I2C
Should be of course #ifdef CONFIG_I2C
But this should not provide such warnings...

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
