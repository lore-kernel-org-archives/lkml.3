Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab3D3COk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:14:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39043 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3D3COi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:14:38 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-c8-517f290c7290
From: Jingoo Han <jg1.han@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Jingoo Han <jg1.han@samsung.com>
References: <000e01ce44bc$e5d1dec0$b1759c40$@samsung.com>
 <20130429180235.GD5183@roeck-us.net>
In-reply-to: <20130429180235.GD5183@roeck-us.net>
Subject: Re: [PATCH RESEND 4/7] watchdog: nuc900_wdt: use devm_*() functions
Date: Tue, 30 Apr 2013 11:14:35 +0900
Message-id: <000601ce4548$761d8110$62588330$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIPNc/yQg9abX0vrVsts5blKUU0OgGhnmVtmF8U/9A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY10ezfpAgy2dshZz1q9hs7i88BKr
	xeVdc9gsbqzbx27xZOEZJovdK5ewWNya8YLVgd2jb8pVNo9rm8U8Tsz4zeKx83sDUGjLKkaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDJ+/bzCXLBTsqLr+xrWBsatIl2MnBwSAiYSn54eYYOwxSQu
	3FsPZHNxCAksY5T4Mu0zM0zRj1XvGSES0xkl3jxeBlX1i1HiwNPVYFVsAmoSX74cZgexRQQ0
	JK5PmQPWwSzwhlFi07wfTCAJIYEEiWnnt4Ht4xQwlDh6diOYLSzgI7GvcxWQzcHBIqAqceK8
	LUiYV8BSYtrzrywQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17yFulRBYsfZ14wQN1hJHHr2AKpe
	RGLfi3dg90gIfGWXuL93H1gDi4CAxLfJh1hA9koIyEpsOgA1R1Li4IobLBMYJWYhWT0LyepZ
	SFbPQrJiASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQSO7bwXjzgPUhxmSg9ROZpUST
	84GJIK8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jL4im5J6K6ZbO7Ftuljcaf+262W868Fl7Y4ClzoKL+tLTv0itsV7U44/W8aqcPe4yF0Hj364
	LB4i//dXOI/6uquqDx1W+ug8r71pq3VzvuU2r2VJxQkSrck1IiypgU/2O/ku3684N7OVqb+O
	51H8I3GJ3ofi+c/5r7MlmX0+4bjv/VTOMz/4lViKMxINtZiLihMBCUB/o/oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQV0ezfpAg+2bJSzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa7Vy5hsbg14wWrA7tH35SrbB7XNot5nJjxm8Vj5/cGoNCWVYwe
	nzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gDdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+PXzCnPBTsmKru9r
	WBsYt4p0MXJySAiYSPxY9Z4RwhaTuHBvPVsXIxeHkMB0Rok3j5dBOb8YJQ48Xc0MUsUmoCbx
	5cthdhBbREBD4vqUOYwgRcwCbxglNs37wQSSEBJIkJh2fhsbiM0pYChx9OxGMFtYwEdiX+cq
	IJuDg0VAVeLEeVuQMK+ApcS0519ZIGxBiR+T74HZzAJaEut3HmeCsOUlNq95ywxxqYLEjrOv
	GSFusJI49OwBVL2IxL4X7xgnMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4DTxTHoH46oGi0OMAhyMSjy8O5bUBQqxJpYVV+YeYpTgYFYS4a3jrQ8U4k1J
	rKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgCssriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6
	YklqdmpqQWoRzBYmDk6pBkbewtll+psu5hyd8o03zMbqIov2i3M2eQX7/TP32a/KNRVimMmZ
	e0zx3S2P+dMfVG+4FZX48tn/I1yuZxNOPuC9IR7yPvog96ZTEeYf7ufKn1fzn54yU7f+J9ta
	8ROJk/tqbR+s7Nq7deVyQ/2Tdf1dLD9C235cmrTu1/tv7iIR5VWZm8s2cqYosRRnJBpqMRcV
	JwIAD/8/V1cDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Guenter Roeck [mailto:linux@roeck-us.net]
> Sent: Tuesday, April 30, 2013 3:03 AM
> To: Jingoo Han
> Cc: 'Andrew Morton'; linux-kernel@vger.kernel.org; 'Wim Van Sebroeck'; linux-watchdog@vger.kernel.org
> Subject: Re: [PATCH RESEND 4/7] watchdog: nuc900_wdt: use devm_*() functions
> 
> On Mon, Apr 29, 2013 at 06:35:33PM +0900, Jingoo Han wrote:
> > Use devm_*() functions to make cleanup paths simpler.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/watchdog/nuc900_wdt.c |   45 ++++++++--------------------------------
> >  1 files changed, 9 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
> > index 04c45a1..89e8991 100644
> > --- a/drivers/watchdog/nuc900_wdt.c
> > +++ b/drivers/watchdog/nuc900_wdt.c
> > @@ -246,7 +246,8 @@ static int nuc900wdt_probe(struct platform_device *pdev)
> >  {
> >  	int ret = 0;
> >
> > -	nuc900_wdt = kzalloc(sizeof(struct nuc900_wdt), GFP_KERNEL);
> > +	nuc900_wdt = devm_kzalloc(&pdev->dev, sizeof(struct nuc900_wdt),
> > +				GFP_KERNEL);
> 
> General hint: sizeof(*nuc900_wdt) is preferred by most maintainers.

OK, I will fix it.

> 
> >  	if (!nuc900_wdt)
> >  		return -ENOMEM;
> >
> > @@ -257,30 +258,18 @@ static int nuc900wdt_probe(struct platform_device *pdev)
> >  	nuc900_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	if (nuc900_wdt->res == NULL) {
> 
> It is no longer necessary to save the resource in nuc900_wdt, as it is only
> used in the probe function. So you might as well drop the variable from the
> structure and declare it locally.

OK, I will drop 'nuc900_wdt->res' variable from the 'nuc900_wdt' structure and
declare it as logical variable.

> 
> >  		dev_err(&pdev->dev, "no memory resource specified\n");
> > -		ret = -ENOENT;
> > -		goto err_get;
> > +		return -ENOENT;
> >  	}
> >
> > -	if (!request_mem_region(nuc900_wdt->res->start,
> > -				resource_size(nuc900_wdt->res), pdev->name)) {
> > -		dev_err(&pdev->dev, "failed to get memory region\n");
> > -		ret = -ENOENT;
> > -		goto err_get;
> > -	}
> > -
> > -	nuc900_wdt->wdt_base = ioremap(nuc900_wdt->res->start,
> > -					resource_size(nuc900_wdt->res));
> > -	if (nuc900_wdt->wdt_base == NULL) {
> > -		dev_err(&pdev->dev, "failed to ioremap() region\n");
> > -		ret = -EINVAL;
> > -		goto err_req;
> > -	}
> > +	nuc900_wdt->wdt_base = devm_ioremap_resource(&pdev->dev,
> > +						nuc900_wdt->res);
> > +	if (IS_ERR(nuc900_wdt->wdt_base))
> > +		return PTR_ERR(nuc900_wdt->wdt_base);
> >
> Does devm_ioremap_resource() spit out an error if it fails ?
> If not, you might want to add an error message for consistency
> with the other messages.

I CC'ed Thierry Reding who is the author of devm_ioremap_resource().

Um, devm_ioremap_resource() spits out an error if it fails.

According to commit message of the previous patch made by Thierry Reding,

"devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths."

Thus, there is no need to add an error message.

Best regards,
Jingoo Han

> 
> Thanks,
> Guenter

