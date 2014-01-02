Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaABCfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:35:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:9702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaABCfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:35:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,588,1384329600"; 
   d="scan'208";a="452533521"
Message-ID: <1388630103.3739.71.camel@rzhang1-mobl4>
Subject: Re: [PATCH] drivers: thermal: Mark function as static in
 x86_pkg_temp_thermal.c
From: Zhang Rui <rui.zhang@intel.com>
To: josh@joshtriplett.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org
Date: Thu, 02 Jan 2014 10:35:03 +0800
In-Reply-To: <20131218184014.GD24229@cloud>
References: <20131218174602.GA27918@rashika> <20131218184014.GD24229@cloud>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 10:40 -0800, josh@joshtriplett.org wrote:
> On Wed, Dec 18, 2013 at 11:16:02PM +0530, Rashika Kheria wrote:
> > Mark function sys_set_trip_temp() as static in x86_pkg_temp_thermal.c
> > because it is not used outside this file.
> > 
> > This eliminates the following warning in x86_pkg_temp_thermal.c:
> > drivers/thermal/x86_pkg_temp_thermal.c:218:5: warning: no previous prototype for ‘sys_set_trip_temp’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
applied.

thanks,
rui
> >  drivers/thermal/x86_pkg_temp_thermal.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/thermal/x86_pkg_temp_thermal.c b/drivers/thermal/x86_pkg_temp_thermal.c
> > index 7722cb9..972e1c7 100644
> > --- a/drivers/thermal/x86_pkg_temp_thermal.c
> > +++ b/drivers/thermal/x86_pkg_temp_thermal.c
> > @@ -215,7 +215,7 @@ static int sys_get_trip_temp(struct thermal_zone_device *tzd,
> >  	return 0;
> >  }
> >  
> > -int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
> > +static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
> >  							unsigned long temp)
> >  {
> >  	u32 l, h;
> > -- 
> > 1.7.9.5
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


