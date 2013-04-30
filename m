Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab3D3B4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:56:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54174 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab3D3B4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:56:40 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-a4-517f24d7869d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <000d01ce44bc$da891380$8f9b3a80$@samsung.com>
 <20130429175507.GC5183@roeck-us.net>
In-reply-to: <20130429175507.GC5183@roeck-us.net>
Subject: Re: [PATCH RESEND 3/7] watchdog: mv64x60_wdt: use devm_ioremap()
Date: Tue, 30 Apr 2013 10:56:39 +0900
Message-id: <000501ce4545$f43495f0$dc9dc1d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI0t2rRvy2CQkyK2RfXHP9wLn9zKwJCCOI2mA8MQTA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zQ93rKvWBBj82SFnMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANYoLpuU
	1JzMstQifbsErowTN9cyF0zjq2ja4dLAuIq7i5GTQ0LARKJtyg4WCFtM4sK99WxdjFwcQgLL
	GCU61r9mgilq+XiKBSKxiFGie9M9ZgjnF6PEp/5bjCBVbAJqEl++HGYHsUUENCSuT5nDCFLE
	LLCdUWLP4ldgo4QEEiSu3v4BtIODg1PAUOLjTReQsLCAp8SnlmXMIDaLgKrEzuafYDN5BSwl
	Jt+7zwZhC0r8mHwP7FRmAS2J9TuPM0HY8hKb17xlhrhUQWLH2deMEDdYSXxYNoURokZEYt+L
	d2D3SAi8ZJdYvXkzK8QyAYlvkw+xgNwjISArsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZPQvJ
	igWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQmK2bwfjzQPWhxiTgdZPZJYSTc4Hxnxe
	SbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgLlp78
	rP/r9IdfAtP3Nu96w+ux3YCnq180T8KvNiWX8d49ab2E1Ru+ruLUl7U5+I+hZJPA9Jsralyj
	fry7xZwy+fImJm6WycI2fKEdmZ/tJh/z6pmzk+l8v9tSnthvHXJ2L6ZO1Jmw7+HphYf+HXGd
	evKUl+zlExvO3UpvPFKfwivEeuL6v/gzSizFGYmGWsxFxYkA2DJ/LO8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd3rKvWBBg37xCzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMEzfXMhdM46to2uHSwLiKu4uRk0NC
	wESi5eMpFghbTOLCvfVsXYxcHEICixglujfdY4ZwfjFKfOq/xQhSxSagJvHly2F2EFtEQEPi
	+pQ5jCBFzALbGSX2LH7FBJIQEkiQuHr7B9AoDg5OAUOJjzddQMLCAp4Sn1qWMYPYLAKqEjub
	f4LN5BWwlJh87z4bhC0o8WPyPbCLmAW0JNbvPM4EYctLbF7zlhniUgWJHWdfM0LcYCXxYdkU
	RogaEYl9L94xTmAUmoVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GMEJ4Zn0DsZVDRaHGAU4GJV4eHcsqQsUYk0sK67MPcQowcGsJMJbx1sfKMSbklhZlVqUH19U
	mpNafIgxGejTicxSosn5wGSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2MzFuSWRk59rFdnLz/hFZ9nKnKwe1TJv14lpL/UZ1nHytDafq/hHvZaUrrjXqy
	ns+WYr82o9ZkLYee4wTtyOI/K3hzvunG2R+b/+rJFfVPew+kfDri/fa3yZSW1WxLNkgAg/nx
	K9k59/m+iNj2Kj2rOjxvQ98PB6fPh/PsWxtqLcSnejUdYD+pxFKckWioxVxUnAgARG4dTkwD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 2:55 AM, Guenter Roeck wrote:
> On Mon, Apr 29, 2013 at 06:35:15PM +0900, Jingoo Han wrote:
> > Use devm_ioremap() to make cleanup paths simpler.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> This patch also addresses the missing call to iounmap() if the call
> to misc_register fails.

When devm_ioremap() is used, there is no need to call devm_iounmap().

It is because, these resource managed functions such as
devm_ioremap() allow the driver core to automatically
clean up any allocation, when probe function fails.

> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thank you for your reviewing.

Best regards,
Jingoo Han

> 
> > ---
> >  drivers/watchdog/mv64x60_wdt.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
> > index c7fb878..e4cf980 100644
> > --- a/drivers/watchdog/mv64x60_wdt.c
> > +++ b/drivers/watchdog/mv64x60_wdt.c
> > @@ -276,7 +276,7 @@ static int mv64x60_wdt_probe(struct platform_device *dev)
> >  	if (!r)
> >  		return -ENODEV;
> >
> > -	mv64x60_wdt_regs = ioremap(r->start, resource_size(r));
> > +	mv64x60_wdt_regs = devm_ioremap(&dev->dev, r->start, resource_size(r));
> >  	if (mv64x60_wdt_regs == NULL)
> >  		return -ENOMEM;
> >
> > @@ -293,8 +293,6 @@ static int mv64x60_wdt_remove(struct platform_device *dev)
> >
> >  	mv64x60_wdt_handler_disable();
> >
> > -	iounmap(mv64x60_wdt_regs);
> > -
> >  	return 0;
> >  }
> >
> > --
> > 1.7.2.5
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

