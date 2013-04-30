Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab3D3ByL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:54:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54807 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3D3ByG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:54:06 -0400
X-AuditID: cbfee690-b7f136d000000fea-bd-517f243c8070
From: Jingoo Han <jg1.han@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <000901ce44bc$38dcfbf0$aa96f3d0$@samsung.com>
 <20130429164425.GJ23799@roeck-us.net>
In-reply-to: <20130429164425.GJ23799@roeck-us.net>
Subject: Re: [PATCH RESEND 1/2] watchdog: mtx1-wdt: use devm_gpio_request_one()
Date: Tue, 30 Apr 2013 10:54:03 +0900
Message-id: <000401ce4545$979de350$c6d9a9f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDLfbMyDwsVGaIdQ36Nf0Ypb3ytTwNQrbczmtkH2QA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zY10blfpAg5mzeCzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8a90/tZCtbzV/TsvsDWwLiZp4uRk0NCwETi74w9jBC2mMSFe+vZuhi5OIQE
	ljFK7OjtYIcp2rZ8PRNEYhGjxOeGqSwQzi9GiZ67U5lBqtgE1CS+fDkM1iEioCFxfcocRpAi
	ZoHtjBJ7Fr9iAkkICSRKHD7ZDNbAKWAkcXPqDTYQW1jAX2LXq5MsIDaLgKrEy+cbwOK8ApYS
	U07fZYGwBSV+TL4HZjMLaEms33mcCcKWl9i85i0zxKkKEjvOvmaEOMJKom3NG1aIGhGJfS/e
	gR0kIfCSXeL2m69sEMsEJL5NPgQ0lAMoISux6QDUHEmJgytusExglJiFZPUsJKtnIVk9C8mK
	BYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFC4nbCDsZ7B6wPMSYDrZ/ILCWanA+M+7yS
	eENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJo/ersk
	eU5vu6DiyfT1ce4H42YeWLvrzbzjbTnCLw9OePhw/QK7M2+Yytb90btUXRB5vzLIt2C9Yni8
	28e3R6fKzmVyiKifF8t7Za644Akpm/YZdsdeRJlpGD4UuLg6NX7hGz4bxxnT7+1ymC7hLD1j
	gnbr39Db8+LuvGxelXMkuuY6S/TWlUlKLMUZiYZazEXFiQBMLfkw8QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAV0blfpAg9lv2C3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMe6f3sxSs56/o2X2BrYFxM08XIyeH
	hICJxLbl65kgbDGJC/fWs3UxcnEICSxilPjcMJUFwvnFKNFzdyozSBWbgJrEly+H2UFsEQEN
	ietT5jCCFDELbGeU2LP4FdgoIYFEicMnm8EaOAWMJG5OvcEGYgsL+EvsenWSBcRmEVCVePl8
	A1icV8BSYsrpuywQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlhjhVQWLH2deMEEdYSbStecMK
	USMise/FO8YJjEKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMj
	OCk8k97BuKrB4hCjAAejEg/vjiV1gUKsiWXFlbmHGCU4mJVEeOt46wOFeFMSK6tSi/Lji0pz
	UosPMSYDfTqRWUo0OR+YsPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoE
	s4WJg1OqgbGXYcnaq73/WosXszm5/X/5+I/73MV8ZwT8rmlefe36Un3nSfGs2Rksj8Ufi7g1
	56kbzGlb3fZltuDZPfP3zGbiPLGM465HXdlMg6fZnz9e79le2S6dI/1ANHvuzjmWm0LiK3I/
	PF/4Quuk4ftsDdlDew8JMPXMlDj6+9jK58IfGs0P5zjdNTBQYinOSDTUYi4qTgQAfiQoMU4D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 1:44 AM, Guenter Roeck wrote:
> On Mon, Apr 29, 2013 at 06:30:43PM +0900, Jingoo Han wrote:
> > Use devm_gpio_request_one() to make cleanup paths simpler.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> This patch also addresses the missing gpio_free in the probe error path
> (if the call to misc_register() fails).

When devm_gpio_request_one() is used, there is no need to call
devm_gpio_free().

It is because, these resource managed functions such as
devm_gpio_request_one() allow the driver core to automatically
clean up any allocation, when probe function fails.

> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thank you for your reviewing.

Best regards,
Jingoo Han

> 
> > ---
> >  drivers/watchdog/mtx-1_wdt.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
> > index 14dab6f..b434111 100644
> > --- a/drivers/watchdog/mtx-1_wdt.c
> > +++ b/drivers/watchdog/mtx-1_wdt.c
> > @@ -209,7 +209,7 @@ static int mtx1_wdt_probe(struct platform_device *pdev)
> >  	int ret;
> >
> >  	mtx1_wdt_device.gpio = pdev->resource[0].start;
> > -	ret = gpio_request_one(mtx1_wdt_device.gpio,
> > +	ret = devm_gpio_request_one(&pdev->dev, mtx1_wdt_device.gpio,
> >  				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
> >  	if (ret < 0) {
> >  		dev_err(&pdev->dev, "failed to request gpio");
> > @@ -241,7 +241,6 @@ static int mtx1_wdt_remove(struct platform_device *pdev)
> >  		wait_for_completion(&mtx1_wdt_device.stop);
> >  	}
> >
> > -	gpio_free(mtx1_wdt_device.gpio);
> >  	misc_deregister(&mtx1_wdt_misc);
> >  	return 0;
> >  }
> > --
> > 1.7.2.5
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

