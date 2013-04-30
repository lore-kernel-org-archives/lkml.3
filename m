Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839Ab3D3AyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:54:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42422 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619Ab3D3AyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:54:11 -0400
X-AuditID: cbfee68f-b7f066d000003683-3d-517f16325a4d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Pavel Machek'" <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <000001ce42f2$96128cc0$c237a640$@samsung.com>
 <20119404.Sfu5WntByi@vostro.rjw.lan>
 <000001ce449c$3e1ce0f0$ba56a2d0$@samsung.com> <517E63C8.6040809@metafoo.de>
In-reply-to: <517E63C8.6040809@metafoo.de>
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
Date: Tue, 30 Apr 2013 09:54:09 +0900
Message-id: <000101ce453d$39611b70$ac235250$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGZyojvIl/md4KPBeuZMYPjUO77jQIGGS6nAdetXXwBsohUlpkqYgbQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zfV0jsfpAg9fzWCzmrF/DZnF54SVW
	iyWT57NazJqyl8ni8q45bBafe48wWtw9dZTNon9hL5MDh8fiPS+ZPE7M+M3iseTNIVaPvi2r
	GD0eLW5h9Fix+ju7x+dNcgHsUVw2Kak5mWWpRfp2CVwZ8+ZrFBwUqlh4/w97A+MX3i5GDg4J
	AROJ2U91uhg5gUwxiQv31rN1MXJxCAksY5S427KECSJhInFn4WyoxHRGie6mDawQzi9GibdT
	/rOBVLEJqEl8+XKYHcQWEdCSmPrtLVgRs8A3Ronzh+ZAta9jlOg/1swKUsUJVLXi5BxmkDuE
	BfQlji/1AAmzCKhK3Gj9zghi8wpYShx4eIQJwhaU+DH5HgtIObOAusSUKbkgYWYBeYnNa94y
	Q1yqILHj7GtGiBvcJKaceMUMUSMise/FO0aQEyQEWjkk1jdOYIbYJSDxbfIhFkhQyEpsOgA1
	R1Li4IobLBMYJWYh2TwLYfMsJJtnIdmwgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZI
	ZPfvYLx7wPoQYzLQ9onMUqLJ+cDEkFcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2
	ampBalF8UWlOavEhRiYOTqkGRtdrT4LnJJSUrT6lkXDCZ/+73Xo77NILP6t3+3Q/fs2sWjvZ
	eHGf0aRVQnas4r3dbavsDRn3mFnXleS1ut7tqD7mf9Rih64DU8Eah8OHeovb1be7cVz/8WX9
	tvyYOS8mXjzP1xMwq/FdQteRtdcnnxdriJ70b/su1bW1Ybbnj6h1pi/rmnw4U4mlOCPRUIu5
	qDgRAMoCIA4CAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jQV1DsfpAg0nPbCzmrF/DZnF54SVW
	iyWT57NazJqyl8ni8q45bBafe48wWtw9dZTNon9hL5MDh8fiPS+ZPE7M+M3iseTNIVaPvi2r
	GD0eLW5h9Fix+ju7x+dNcgHsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAZykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesY
	M+bN1yg4KFSx8P4f9gbGL7xdjJwcEgImEncWzmaDsMUkLtxbD2RzcQgJTGeU6G7awArh/GKU
	eDvlP1gVm4CaxJcvh9lBbBEBLYmp396CFTELfGOUOH9oDlT7OkaJ/mPNrCBVnEBVK07OYe5i
	5OAQFtCXOL7UAyTMIqAqcaP1OyOIzStgKXHg4REmCFtQ4sfkeywg5cwC6hJTpuSChJkF5CU2
	r3nLDHGpgsSOs68ZIW5wk5hy4hUzRI2IxL4X7xgnMArNQjJpFsKkWUgmzULSsYCRZRWjaGpB
	ckFxUnqukV5xYm5xaV66XnJ+7iZGcOJ4Jr2DcVWDxSFGAQ5GJR7eHUvqAoVYE8uKK3MPMUpw
	MCuJ8Nbx1gcK8aYkVlalFuXHF5XmpBYfYkwG+nMis5Rocj4wqeWVxBsam5gZWRqZWRiZmJuT
	Jqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2MOs36Se/vCZ8udpXfaTjSbnHXs6UZPLeYn
	ZscuVCxbsuJT4iLTQ4y3eAWNMptUFDikXy7d4L9O4qmDrNHT5S5Fb1NWVV+z1RTtmrlzrf12
	+3X+yrsjOZR6RQ+d6Pb6ON37avmpmm2+qz7vOC9Xy9bPwTbncfh2N/PrMhIB31JK96xl+reg
	J0OJpTgj0VCLuag4EQBDwAl6YAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 29, 2013 9:13 PM, Lars-Peter Clausen wrote:
> On 04/29/2013 07:41 AM, Jingoo Han wrote:
> > On Saturday, April 27, 2013 11:41 PM, Rafael J. Wysocki:
> >>
> >> On Saturday, April 27, 2013 11:54:50 AM Jingoo Han wrote:
> >>> Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
> >>> to be assigned without having an #define xxx NULL for the case that PM is
> >>> not enabled.
> >>>
> >>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >>
> >> First, I'm not taking any more PM patches for v3.10 (that don't fix recent
> >> regressions).
> >>
> >> Second, please add that macro along with a user.
> >
> > Hi Rafael,
> >
> > This macro can be used as below:
> > This macro cannot affect the procedure of suspend/resume
> > calls; thus, there is no side effect.
> > It just reduces the code size of each drivers.
> > In this way, of_match_ptr() macro has been already used.
> >
> >
> > --- a/drivers/i2c/busses/i2c-s3c2410.c
> > +++ b/drivers/i2c/busses/i2c-s3c2410.c
> > @@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *dev)
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_PM
> >  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
> >  #ifdef CONFIG_PM_SLEEP
> >         .suspend_noirq = s3c24xx_i2c_suspend_noirq,
> > @@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
> >  #endif
> >  };
> >
> > -#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
> > -#else
> > -#define S3C24XX_DEV_PM_OPS NULL
> > -#endif
> > -
> >  /* device driver for platform bus bits */
> >
> >  static struct platform_driver s3c24xx_i2c_driver = {
> > @@ -1240,7 +1234,7 @@ static struct platform_driver s3c24xx_i2c_driver = {
> >         .driver         = {
> >                 .owner  = THIS_MODULE,
> >                 .name   = "s3c-i2c",
> > -               .pm     = S3C24XX_DEV_PM_OPS,
> > +               .pm     = pm_ops_ptr(&s3c24xx_i2c_dev_pm_ops),
> >                 .of_match_table = of_match_ptr(s3c24xx_i2c_match),
> >         },
> >  };
> 
> Won't that generate a warning about an unused s3c24xx_i2c_dev_pm_ops when
> CONFIG_PM is not enabled?

No, there is no build warning, when CONFIG_PM is not enabled.
In this way, of_match_ptr() macro has been already used
without build warnings.


Best regards,
Jingoo Han


