Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab3D3AVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:21:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36889 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3D3AVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:21:41 -0400
X-AuditID: cbfee690-b7f136d000000fea-e7-517f0e8e235f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Len Brown'" <len.brown@intel.com>,
        "'Pavel Machek'" <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <000001ce42f2$96128cc0$c237a640$@samsung.com>
 <20119404.Sfu5WntByi@vostro.rjw.lan>
 <000001ce449c$3e1ce0f0$ba56a2d0$@samsung.com>
 <2369076.UqXRQJTAqK@vostro.rjw.lan>
In-reply-to: <2369076.UqXRQJTAqK@vostro.rjw.lan>
Subject: Re: [PATCH] PM: Add pm_ops_ptr() macro
Date: Tue, 30 Apr 2013 09:21:34 +0900
Message-id: <000001ce4538$abc98940$035c9bc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGZyojvIl/md4KPBeuZMYPjUO77jQIGGS6nAdetXXwBp4mjspkqsU7w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t8zY90+vvpAg+V7DC3mrF/DZnF54SVW
	i1lT9jJZXN41h83ic+8RRou7p46yWfQv7GVyYPdYvOclk8eJGb9ZPPq2rGL0eLS4hdFjxerv
	7B6fN8kFsEVx2aSk5mSWpRbp2yVwZfx70Mpc0Cpdcf/dOaYGxlaRLkZODgkBE4lfpz8zQ9hi
	EhfurWfrYuTiEBJYxihxau9cFpiir5smsEIkFjFKXF+4hwkkISTwC6jqbRKIzSagJvHly2H2
	LkYODhEBdYljJ0VA6pkFzjNKPJj9DKp5G6PEkU/rwJo5BQwkfr6dzQLSICygL3F8qQdImEVA
	VeJG4xRWEJtXwFKicXofO4QtKPFj8j2wcmag+VOm5IKEmQXkJTaveQv1gILEjrOvGUFsEQE3
	iXfnl7JD1IhI7HvxjhHkBAmBn+wSd1tuskPsEpD4NvkQ2EwJAVmJTQeg5khKHFxxg2UCo8Qs
	JJtnIWyehWTzLCQbFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIieIJOxjvHbA+xJgM
	tH0is5Rocj4wCeSVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgdFu65EV7WJG3+fY3rJZ7xIwTebSmv274g32i2pZecq0sT63jOFWa/547zhjx3ve
	f+rfn8SunVDwO2ZyiYQI88X19Xt2PN7DzR8XeUPQWkIx03RrmkbT7+byhPKpehPaZfxu/nxz
	3/5B+SPtu64hlq/Nr+Stn58d77it2P+UbNxilZBnxl4sN5RYijMSDbWYi4oTAc3qWGr4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jAd0+vvpAg4VPdCzmrF/DZnF54SVW
	i1lT9jJZXN41h83ic+8RRou7p46yWfQv7GVyYPdYvOclk8eJGb9ZPPq2rGL0eLS4hdFjxerv
	7B6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAB2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8z496CVuaBVuuL+
	u3NMDYytIl2MnBwSAiYSXzdNYIWwxSQu3FvP1sXIxSEksIhR4vrCPUwgCSGBX4wSp94mgdhs
	AmoSX74cZu9i5OAQEVCXOHZSBKSeWeA8o8SD2c9YIZq3MUoc+bQOrJlTwEDi59vZLCANwgL6
	EseXeoCEWQRUJW40TgFbzCtgKdE4vY8dwhaU+DH5Hlg5M9D8KVNyQcLMAvISm9e8ZYa4U0Fi
	x9nXjCC2iICbxLvzS9khakQk9r14xziBUWgWkkmzECbNQjJpFpKOBYwsqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGCU8Qz6R2MqxosDjEKcDAq8fDuWFIXKMSaWFZcmXuIUYKDWUmE9/RN
	oBBvSmJlVWpRfnxRaU5q8SHGZKA/JzJLiSbnA9NXXkm8obGJmZGlkZmFkYm5OWnCSuK8B1ut
	A4UE0hNLUrNTUwtSi2C2MHFwSjUwWuzgX932QKi6+eWSyuNVvD8ZdWV3yFzje3TgbtsiyTlH
	/hstkJdg6fO/JfRsZnJT0fXPk4Jialv735ZzLNBZmbSgvnBqWGf4w/xj9+4eehoiVc5U166b
	efXuT5n/Pq/LVz6R37du44HWDEU74xPaMkmrhVwvlpVcVqn+nvnZKJ4x4l1bYuUzJZbijERD
	Leai4kQA1SB2E1UDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 29, 2013 8:35 PM, Rafael J. Wysocki:
> On Monday, April 29, 2013 02:41:48 PM Jingoo Han wrote:
> > On Saturday, April 27, 2013 11:41 PM, Rafael J. Wysocki:
> > >
> > > On Saturday, April 27, 2013 11:54:50 AM Jingoo Han wrote:
> > > > Add pm_ops_ptr() macro that allows the .pm entry in the driver structures
> > > > to be assigned without having an #define xxx NULL for the case that PM is
> > > > not enabled.
> > > >
> > > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > >
> > > First, I'm not taking any more PM patches for v3.10 (that don't fix recent
> > > regressions).
> > >
> > > Second, please add that macro along with a user.
> >
> > Hi Rafael,
> >
> > This macro can be used as below:
> > This macro cannot affect the procedure of suspend/resume
> > calls; thus, there is no side effect.
> > It just reduces the code size of each drivers.
> > In this way, of_match_ptr() macro has been already used.
> 
> OK, so care to fold the below into your original patch?

OK, I will fold it into my original patch.
Then, I will send v2 patch, soon.
Thank you.

Best regards,
Jingoo Han

> 
> Rafael
> 
> 
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
> >
> > Best regards,
> > Jingoo Han
> >
> >
> > >
> > > Thanks,
> > > Rafael
> > >
> > >
> > > > ---
> > > >  include/linux/pm.h |    2 ++
> > > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > > > index a224c7f..bd50d15 100644
> > > > --- a/include/linux/pm.h
> > > > +++ b/include/linux/pm.h
> > > > @@ -55,8 +55,10 @@ struct device;
> > > >
> > > >  #ifdef CONFIG_PM
> > > >  extern const char power_group_name[];		/* = "power" */
> > > > +#define pm_ops_ptr(_ptr)	(_ptr)
> > > >  #else
> > > >  #define power_group_name	NULL
> > > > +#define pm_ops_ptr(_ptr)	NULL
> > > >  #endif
> > > >
> > > >  typedef struct pm_message {
> > > >
> > > --
> > > I speak only for myself.
> > > Rafael J. Wysocki, Intel Open Source Technology Center.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

