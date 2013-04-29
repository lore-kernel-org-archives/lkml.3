Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab3D2Flw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 01:41:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37157 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3D2Flu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 01:41:50 -0400
X-AuditID: cbfee68f-b7f066d000003683-f4-517e081cc9b3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Pavel Machek'" <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <000001ce42f2$96128cc0$c237a640$@samsung.com>
 <20119404.Sfu5WntByi@vostro.rjw.lan>
In-reply-to: <20119404.Sfu5WntByi@vostro.rjw.lan>
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
Date: Mon, 29 Apr 2013 14:41:48 +0900
Message-id: <000001ce449c$3e1ce0f0$ba56a2d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGZyojvIl/md4KPBeuZMYPjUO77jQIGGS6nmUVwj5A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zQ11ZjrpAg/XXGS3mrF/DZnF54SVW
	i1lT9jJZXN41h83ic+8RRou7p46yWfQv7GVyYPdYvOclk8eJGb9ZPPq2rGL0eLS4hdFjxerv
	7B6fN8kFsEVx2aSk5mSWpRbp2yVwZWzY0MZUcEq44s2mFuYGxk98XYycHBICJhKdfz6xQdhi
	EhfurQeyuTiEBJYxSpz78YwJpmjx2WXsEInpjBJL70+DqvrFKPFu7WwWkCo2ATWJL18Os4PY
	IgJhErO2HQIrYhZYxCjxZtVWZpCEkECCxPkbL8HGcgoYSky73wwU5+AQFtCXOL7UAyTMIqAq
	ce5lF1g5r4ClRM+0blYIW1Dix+R7YLuYBdQlJs1bxAxhy0tsXvOWGeJSBYkdZ18zQtxgJbGs
	YRYrRI2IxL4X7xhB7pEQ+MoucX3lfiaIZQIS3yYfYgG5QUJAVmLTAag5khIHV9xgmcAoMQvJ
	6llIVs9CsnoWkhULGFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoTEcv8OxrsHrA8xJgOt
	n8gsJZqcD0wFeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9i
	ZOLglGpgDH38+sDclTPMXro5H9/IsKD87o+eDSvf9i+XO3ym0vbTpUSFpmWJpQcObqq5/+BN
	U7SBqvoU9v6jhd9vWltHx8k8X6+j/sO/+3Yyn/uN9fXh8xQuWPqYmfBfiVi/KCAqxefwoxo/
	1/c6p9RWNnBKTTbJLKmYI8v/QelwjLz4u6+f2a8/tWhbpMRSnJFoqMVcVJwIACoXCP37AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQV0ZjrpAg6VHrCzmrF/DZnF54SVW
	i1lT9jJZXN41h83ic+8RRou7p46yWfQv7GVyYPdYvOclk8eJGb9ZPPq2rGL0eLS4hdFjxerv
	7B6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAB2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zYsKGNqeCUcMWb
	TS3MDYyf+LoYOTkkBEwkFp9dxg5hi0lcuLeerYuRi0NIYDqjxNL706CcX4wS79bOZgGpYhNQ
	k/jy5TBYh4hAmMSsbYfAipgFFjFKvFm1lRkkISSQIHH+xksmEJtTwFBi2v1moDgHh7CAvsTx
	pR4gYRYBVYlzL7vAynkFLCV6pnWzQtiCEj8m3wPbxSygLjFp3iJmCFteYvOat8wQlypI7Dj7
	mhHiBiuJZQ2zWCFqRCT2vXjHOIFRaBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgQnimfSOxhXNVgcYhTgYFTi4Q3YXBsoxJpYVlyZe4hRgoNZSYR39m2gEG9K
	YmVValF+fFFpTmrxIcZkoE8nMkuJJucDk1heSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTS
	E0tSs1NTC1KLYLYwcXBKNTAWzVy59YfQ2z+N3fwx9VsSWNZ8YJWPUj1xo2kDq+CbGsHSjG7+
	dfuurnDZ4LN6wi3/rsIM/ePdty5O1mvfk74k49qk0rn+207bn2dguLtBNOAN3/nH6c+53G9I
	FwgekXxkGyxwVqx+bh+fr92SJZzK4prGUT6z7KvbvdLWrU7Ye91h8hEvliAlluKMREMt5qLi
	RABZ+0cmWAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 27, 2013 11:41 PM, Rafael J. Wysocki:
> 
> On Saturday, April 27, 2013 11:54:50 AM Jingoo Han wrote:
> > Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
> > to be assigned without having an #define xxx NULL for the case that PM is
> > not enabled.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> First, I'm not taking any more PM patches for v3.10 (that don't fix recent
> regressions).
> 
> Second, please add that macro along with a user.

Hi Rafael,

This macro can be used as below:
This macro cannot affect the procedure of suspend/resume
calls; thus, there is no side effect.
It just reduces the code size of each drivers.
In this way, of_match_ptr() macro has been already used.


--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1218,7 +1218,6 @@ static int s3c24xx_i2c_resume(struct device *dev)
 }
 #endif

-#ifdef CONFIG_PM
 static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
 #ifdef CONFIG_PM_SLEEP
        .suspend_noirq = s3c24xx_i2c_suspend_noirq,
@@ -1226,11 +1225,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
 #endif
 };

-#define S3C24XX_DEV_PM_OPS (&s3c24xx_i2c_dev_pm_ops)
-#else
-#define S3C24XX_DEV_PM_OPS NULL
-#endif
-
 /* device driver for platform bus bits */

 static struct platform_driver s3c24xx_i2c_driver = {
@@ -1240,7 +1234,7 @@ static struct platform_driver s3c24xx_i2c_driver = {
        .driver         = {
                .owner  = THIS_MODULE,
                .name   = "s3c-i2c",
-               .pm     = S3C24XX_DEV_PM_OPS,
+               .pm     = pm_ops_ptr(&s3c24xx_i2c_dev_pm_ops),
                .of_match_table = of_match_ptr(s3c24xx_i2c_match),
        },
 };

Best regards,
Jingoo Han


> 
> Thanks,
> Rafael
> 
> 
> > ---
> >  include/linux/pm.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > index a224c7f..bd50d15 100644
> > --- a/include/linux/pm.h
> > +++ b/include/linux/pm.h
> > @@ -55,8 +55,10 @@ struct device;
> >
> >  #ifdef CONFIG_PM
> >  extern const char power_group_name[];		/* = "power" */
> > +#define pm_ops_ptr(_ptr)	(_ptr)
> >  #else
> >  #define power_group_name	NULL
> > +#define pm_ops_ptr(_ptr)	NULL
> >  #endif
> >
> >  typedef struct pm_message {
> >
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

