Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3BVCNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:13:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37336 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3BVCNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:13:04 -0500
X-AuditID: cbfee690-b7f066d00000169f-df-5126d42d910a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Igor Grinberg'" <grinberg@compulab.co.il>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cb01ce100d$dc282200$94786600$%han@samsung.com>
 <5125DF5C.7070700@compulab.co.il>
In-reply-to: <5125DF5C.7070700@compulab.co.il>
Subject: Re: [PATCH] rtc: rtc-v3020: use gpio_request_one()
Date: Fri, 22 Feb 2013 11:13:01 +0900
Message-id: <008901ce10a2$23c9fef0$6b5dfcd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QED48+6yQglucRhW8LTiO1vzyDwAkXkmg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zfV3dK2qBBu0rVCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3ZuTWQouclf8+vedqYGxj7OLkZNDQsBEYtqn18wQtpjEhXvr
	2boYuTiEBJYxSjT+/8UGU/TiwD9miMR0Rok9n4+zQjizmSQur1zGClLFJqAm8eXLYXYQW0RA
	V2L99DZGkCJmgT2MEj93vgErEhJIlLg6+wRQgoODU0BP4tpaL5CwsIC1xPvXfWC9LAKqEssa
	14Jt5hWwlZi38D8LhC0o8WPyPTCbWUBLYv3O40wQtrzE5jVvmUFGSgioSzz6qwtxgpHEnjmP
	oMpFJPa9eMcI8cwidokNPUkQqwQkvk0+xALRKiux6QA0ICQlDq64wTKBUWIWksWzkCyehWTx
	LCQbFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIiawJOxjvHbA+xJgMtH4is5Rocj4w
	MvNK4g2NjU3MTExNzC1NzU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTGK
	Y/PBvftMwrdEZ/fISGrG8x2yVqs+pLLm3+uHtbPk1ueFV/MpBmzy/biKc6biHdOQhoROph0H
	K1b1HZNpX6Da+GLGiUSthAQ21Va1aCdXkXDfigsd0alnj+tMmifVKrIiXMK+WPVgxZHNWnf8
	5/O1y51xlKi5s6g6zGGP3DlxzeUfZB1LlFiKMxINtZiLihMBHXgJgsICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoK7uFbVAg9Y/8haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+7NySwFF7krfv37ztTA
	2MfZxcjJISFgIvHiwD9mCFtM4sK99WxdjFwcQgLTGSX2fD7OCuHMZpK4vHIZK0gVm4CaxJcv
	h9lBbBEBXYn109sYQYqYBfYwSvzc+QasSEggUeLq7BNACQ4OTgE9iWtrvUDCwgLWEu9f94H1
	sgioSixrXMsGYvMK2ErMW/ifBcIWlPgx+R6YzSygJbF+53EmCFteYvOat8wgIyUE1CUe/dWF
	OMFIYs+cR1DlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYIj95n0DsZVDRaHGAU4GJV4eDu81QKFWBPLiitzDzFKcDArifDqhwKFeFMSK6tS
	i/Lji0pzUosPMSYDPTqRWUo0OR+YVPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1
	OzW1ILUIZgsTB6dUA+Oyreyysw53bK76dSDnvY2lnpnOoS3RfVWVImWz1plmcYh659r5zba+
	/uOStxnLw2/Xnu/Id+H5FiC4qelCyLE/x4XftrgenF98K+W8RdcstY9MZQwzdR4U2xXvf8VU
	/0ib20pOcWZrrNvWNvMezZ38OlXFd34pPSmbeKzEX0vo0NUdvHEu2kosxRmJhlrMRcWJANms
	0zYgAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2013 5:48 PM, Igor Grinberg wrote:
> 
> On 02/21/13 10:31, Jingoo Han wrote:
> > Using gpio_request_one() can make the code simpler because it can
> > set the direction and initial value in one shot.
> 
> If you are on this, then I think converting to gpio_request_array()
> would be even better.

Hi Igor Grinberg,

OK, I see.
I will use gpio_request_array() and send v2 patch soon.
Thank you for your comment.


Best regards,
Jingoo Han

> 
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/rtc/rtc-v3020.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
> > index bca5d67..d59cd24 100644
> > --- a/drivers/rtc/rtc-v3020.c
> > +++ b/drivers/rtc/rtc-v3020.c
> > @@ -125,11 +125,10 @@ static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
> >  	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
> >
> >  	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
> > -		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
> > +		err = gpio_request_one(v3020_gpio[i].gpio, GPIOF_OUT_INIT_HIGH,
> > +					v3020_gpio[i].name);
> >  		if (err)
> >  			goto err_request;
> > -
> > -		gpio_direction_output(v3020_gpio[i].gpio, 1);
> >  	}
> 
> If you convert to gpio_request_array(), you can also drop the for loop.
> 
> >
> >  	chip->gpio = v3020_gpio;
> >
> 
> --
> Regards,
> Igor.

