Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaHVHRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:17:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51217 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbaHVHRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:17:43 -0400
X-AuditID: cbfee691-b7f306d000003d81-f1-53f6ee95fa06
From: Jingoo Han <jg1.han@samsung.com>
To: "'Geert Uytterhoeven'" <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org,
        "'Linux Fbdev development list'" <linux-fbdev@vger.kernel.org>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007701cfbdd1$a70486e0$f50d94a0$%han@samsung.com>
 <CAMuHMdUWwwRC1drp6XOxUOY2zDf4qY62OKT4taRthktGgOM=6g@mail.gmail.com>
In-reply-to: <CAMuHMdUWwwRC1drp6XOxUOY2zDf4qY62OKT4taRthktGgOM=6g@mail.gmail.com>
Subject: Re: [PATCH] backlight: platform_lcd: remove unnecessary #ifdef
 CONFIG_OF
Date: Fri, 22 Aug 2014 16:17:40 +0900
Message-id: <008101cfbdd9$28ce10e0$7a6a32a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+92JIsHmMNordiQ+6BZnJr5zizgQAACWOA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zI92p774FG+yaxW1xdOdEJotnt/Yy
	WVxeeInV4v7Xo4wWJ/o+sFpc3jWHzYHNY+esu+wed67tYfM4dLiD0aNvyypGj8+b5AJYo7hs
	UlJzMstSi/TtErgytu55w14wk6fi+zfDBsaLnF2MnBwSAiYSZ16uY4SwxSQu3FvP1sXIxSEk
	sIxR4mzvdCaYoo/Pz0ElFjFK3Hj4nAXC+c0o8XLeT7B2NgE1iS9fDrOD2CIC+hLbFv5jBCli
	FjjLKPG7/SBURwujROuNWawgVZwCwRJTp7xnA7GFgezZN5eATWIRUJU4OfUvmM0rYCtxcl8r
	G4QtKPFj8j2gQRxAU9UlpkzJBQkzC8hLbF7zlhkkLAEUfvRXF+IGI4kf6zezQ5SISOx78Q7s
	HgmBe+wSs84dZYVYJSDxbfIhFoheWYlNB5ghPpaUOLjiBssERolZSBbPQlg8C8niWUg2LGBk
	WcUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRErMTdzDeP2B9iDEZaPtEZinR5HxgzOeVxBsa
	mxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OGyTpmSU4+
	+3WW982SeeO04Mk9/r8TdbuEEp4a8Nxce+OdP0NHSmt6tzSzfsStlxcn1pqf218i4zox/kao
	6Z2jvqcD/m9uYe8qcZi08J1tNqve7r0+Hzc/fPtipfLFr2fF1BUuM39rUfjy68v0H1px8V3S
	sm+Vpb5FLfCy4f7Wq9u0lCvng7kSS3FGoqEWc1FxIgDsRgrW7wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7Ud9+CDabtZLc4unMik8WzW3uZ
	LC4vvMRqcf/rUUaLE30fWC0u75rD5sDmsXPWXXaPO9f2sHkcOtzB6NG3ZRWjx+dNcgGsUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM7buecNeMJOn4vs3wwbGi5xdjJwc
	EgImEh+fn2ODsMUkLtxbD2RzcQgJLGKUuPHwOQuE85tR4uW8n4wgVWwCahJfvhxmB7FFBPQl
	ti38xwhSxCxwllHid/tBqI4WRonWG7NYQao4BYIlpk55D7ZDGMiefXMJ2CQWAVWJk1P/gtm8
	ArYSJ/e1skHYghI/Jt8DGsQBNFVdYsqUXJAws4C8xOY1b5lBwhJA4Ud/dSFuMJL4sX4zO0SJ
	iMS+F+8YJzAKzUIyaBbCoFlIBs1C0rGAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBC
	eCa9g3FVg8UhRgEORiUe3ogvX4OFWBPLiitzDzFKcDArifBumvctWIg3JbGyKrUoP76oNCe1
	+BCjKdCbE5mlRJPzgckqryTe0NjEzMjSyMzCyMTcXEmc92CrdaCQQHpiSWp2ampBahFMHxMH
	p1QD49xXkboNfP2L1FUiWZw1tJaaha69lDDxzqyMrb8quvj632V8mKa+xoTRPr2h0eXugkCP
	XX++7p78trLv9fwWrqIJ9Y2ZdguFff9tfly1xVkutftOM5tLa2mBIqtjksXmrcdNV8wUeijZ
	rcmQFf57ouZH6+XRVxf1Z2rN1yi/sev3I6eft+bsUWIpzkg01GIuKk4EAGH4Qz4eAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 22, 2014 4:13 PM, Jingoo Han wrote:
> On Fri, Aug 22, 2014 at 8:23 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > Remove unnecessary #ifdef CONFIG_OF, because this is already
> > handled by the of_match_ptr macro.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/video/backlight/platform_lcd.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
> > index c3d2e209fc8f..2bca5ca760ee 100644
> > --- a/drivers/video/backlight/platform_lcd.c
> > +++ b/drivers/video/backlight/platform_lcd.c
> > @@ -137,13 +137,11 @@ static int platform_lcd_resume(struct device *dev)
> >  static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
> >                         platform_lcd_resume);
> >
> > -#ifdef CONFIG_OF
> >  static const struct of_device_id platform_lcd_of_match[] = {
> >         { .compatible = "platform-lcd" },
> >         {},
> >  };
> >  MODULE_DEVICE_TABLE(of, platform_lcd_of_match);
> > -#endif
> >
> >  static struct platform_driver platform_lcd_driver = {
> >         .driver         = {
> 
> Doesn't this introduce a compiler warning ("defined but not used") if
> CONFIG_OF is not set?

Hi Geert Uytterhoeven,

Thank you for your feedback. I already tested this patch with both
cases such as CONFIG_OF=y and CONFIG_OF=n.  When CONFIG_OF is not set,
it does NOT make any compile warnings such as "defined but not used".
Thank you.

Best regards,
Jingoo Han

