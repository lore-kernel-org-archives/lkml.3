Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbbAOInO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:43:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34305 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbAOInL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:43:11 -0500
X-AuditID: cbfee61a-f79c06d000004e71-3f-54b77d9c8455
Date: Thu, 15 Jan 2015 09:43:00 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH v2 1/8] thermal: Provide stub for
 thermal_of_cooling_device_register() function
Message-id: <20150115094300.7019081d@amdc2363>
In-reply-to: <20150114183211.GB3672@developer>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-2-git-send-email-l.majewski@samsung.com>
 <20150102185426.GC12485@developer> <20150102190339.GA22356@developer>
 <20150114160106.20aa160b@amdc2363> <20150114183211.GB3672@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jAd05tdtDDNqbtSwer1nMZDH/yDlW
	i/lXrrFaLL37ic3ix+sLbBZr/ipZ9C64ymbx5hG3xeVdc9gsPvceYbSYcX4fk8WThWeYLO5M
	28tmcfhNO6sDn8fOWXfZPR5M3M3msW7aW2aPnd8b2D36tqxi9Nh8utrj8ya5APYoLpuU1JzM
	stQifbsEroxvd+4xF7RqVjxp2cnUwNip0MXIySEhYCJxYeExZghbTOLCvfVsXYxcHEICixgl
	jrfeZIFwfjFKfLuyiA2kikVAVWLygllgHWwCehKf7z5lArFFBLQkTlzazgTSwCwwjUVi9fVe
	dpCEsECqxOW7m8GaeYEa5v6aBBbnBLKvLJvACrHhPJPEojfXwYr4BSQl2v/9gLrJTuLcpw3s
	EM2CEj8m32MBsZkF1CUmzVvEDGFrSzx5d4F1AqPgLCRls5CUzUJStoCReRWjaGpBckFxUnqu
	oV5xYm5xaV66XnJ+7iZGcFw9k9rBuLLB4hCjAAejEg8vg9/2ECHWxLLiytxDjBIczEoivJ05
	QCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8SvZtIUIC6YklqdmpqQWpRTBZJg5OqQbGie3ejKvu
	6szoi7m+8mxz5ZXWaW4CU4KqNv8vvvlmbdDOMDO+hiKH7Uv8vyQENOhGJWSz6tgazpiytD87
	gd1dou6+T9nhFC4Jxctt7q8/XzR4eSj3THaq7uP5wTOdolOMN0XuWjKDfbrlJuecqxct7/LG
	Trc1ErlafYQtWer06bStHn/06mcqsRRnJBpqMRcVJwIAghuv96cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On Wed, Jan 14, 2015 at 04:01:06PM +0100, Lukasz Majewski wrote:
> > Hi Eduardo,
> > 
> > > On Fri, Jan 02, 2015 at 02:54:28PM -0400, Eduardo Valentin wrote:
> > > > On Mon, Dec 22, 2014 at 05:27:41PM +0100, Lukasz Majewski wrote:
> > > > > Odroid U3 fan can work without being registered as OF cooling
> > > > > device (with CONFIG_THERMAL_OF disabled).
> > > > > In this situation it can be controlled via PWM entry at
> > > > > /sys/class/hwmon/hwmon0/pwm1.
> > > > > 
> > > > > Therefore, the thermal_of_cooling_device_register() function
> > > > > needs a stub to allow clean compilation.
> > > > > 
> > > > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > > 
> > > > Acked-by: Eduardo Valentin <edubezval@gmail.com>
> > > 
> > > Sorry, too fast,
> > > 
> > > This is actually
> > > Nacked-by: Eduardo Valentin <edubezval@gmail.com>
> > > 
> > > :-)
> > > 
> > > I get this error:
> > > drivers/thermal/thermal_core.c:1210:1: error: redefinition of
> > > ‘thermal_of_cooling_device_register’
> > >  thermal_of_cooling_device_register(struct device_node *np,
> > >   ^
> > >   In file included from drivers/thermal/thermal_core.c:34:0:
> > >   include/linux/thermal.h:321:1: note: previous definition of
> > >   ‘thermal_of_cooling_device_register’ was here
> > >    thermal_of_cooling_device_register(struct device_node *np,
> > >     ^
> > > 
> > > 
> > > We provide the function in thermal core even if CONFIG_THERMAL_OF
> > > is not set.
> > 
> > Unfortunately the PWM fan subsystem can work perfectly fine without
> > CONFIG_THERMAL.
> > 
> 
> Now I understand what you are trying to do.
> 
> > I think that it would be enough to make something like this in
> > the ./include/linux/thermal.h:
> > 
> > #ifdef CONFIG_THERMAL
> Well, I think it should be the opposite here:
> 
> #ifndef CONFIG_THERMAL
> 
> that is, if no config thermal, then you provide the stub not the other
> way around.

This seems like a better solution :-).

Thanks.

> 
> > 	static inline struct thermal_cooling_device *
> > 		thermal_of_cooling_device_register(struct
> > device_node *np, char *type, void *devdata,
> > 				   const struct
> > 		thermal_cooling_device_ops *ops) {
> > 		return NULL;
> > 	}
> > #else
> > 	[ already present declaration of
> > 	thermal_of_cooling_device_register() ]
> > #endif /* CONFIG_THERMAL */
> 
> 
> > 
> > 
> > 
> > > > 
> > > > > ---
> > > > > Changes for v2:
> > > > > - None
> > > > > ---
> > > > >  include/linux/thermal.h | 14 +++++++++++---
> > > > >  1 file changed, 11 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > > > > index 2de3d9e..871123c 100644
> > > > > --- a/include/linux/thermal.h
> > > > > +++ b/include/linux/thermal.h
> > > > > @@ -328,6 +328,10 @@ thermal_zone_of_sensor_register(struct
> > > > > device *dev, int id, void *data, const struct
> > > > > thermal_zone_of_device_ops *ops); void
> > > > > thermal_zone_of_sensor_unregister(struct device *dev, struct
> > > > > thermal_zone_device *tz); +struct thermal_cooling_device *
> > > > > +thermal_of_cooling_device_register(struct device_node *np,
> > > > > +				   char *type, void *devdata,
> > > > > +				   const struct
> > > > > thermal_cooling_device_ops *); #else
> > > > >  static inline struct thermal_zone_device *
> > > > >  thermal_zone_of_sensor_register(struct device *dev, int id,
> > > > > void *data, @@ -342,6 +346,13 @@ void
> > > > > thermal_zone_of_sensor_unregister(struct device *dev, {
> > > > >  }
> > > > >  
> > > > > +static inline struct thermal_cooling_device *
> > > > > +thermal_of_cooling_device_register(struct device_node *np,
> > > > > +				   char *type, void *devdata,
> > > > > +				   const struct
> > > > > thermal_cooling_device_ops *ops) +{
> > > > > +	return NULL;
> > > > > +}
> > > > >  #endif
> > > > >  struct thermal_zone_device
> > > > > *thermal_zone_device_register(const char *, int, int, void *,
> > > > > struct thermal_zone_device_ops *, @@ -357,9 +368,6 @@ void
> > > > > thermal_zone_device_update(struct thermal_zone_device *); 
> > > > >  struct thermal_cooling_device
> > > > > *thermal_cooling_device_register(char *, void *, const struct
> > > > > thermal_cooling_device_ops *); -struct thermal_cooling_device
> > > > > * -thermal_of_cooling_device_register(struct device_node *np,
> > > > > char *, void *,
> > > > > -				   const struct
> > > > > thermal_cooling_device_ops *); void
> > > > > thermal_cooling_device_unregister(struct
> > > > > thermal_cooling_device *); struct thermal_zone_device
> > > > > *thermal_zone_get_zone_by_name(const char *name); int
> > > > > thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned
> > > > > long *temp); -- 2.0.0.rc2
> > > > > 
> > > 
> > > 
> > 
> > 
> > 
> > -- 
> > Best regards,
> > 
> > Lukasz Majewski
> > 
> > Samsung R&D Institute Poland (SRPOL) | Linux Platform Group



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
