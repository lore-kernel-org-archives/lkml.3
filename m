Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab3BHJzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 04:55:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:42941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3BHJzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 04:55:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="259537241"
Message-ID: <1360317311.2242.82.camel@rzhang1-mobl4>
Subject: RE: [PATCH 5/8] Thermal: Create Thermal map sysfs attributes for a
 zone
From: Zhang Rui <rui.zhang@intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Date: Fri, 08 Feb 2013 17:55:11 +0800
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5927AB1E@BGSMSX101.gar.corp.intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
	 <1360061183-14137-6-git-send-email-durgadoss.r@intel.com>
	 <1360314270.2242.45.camel@rzhang1-mobl4>
	 <4D68720C2E767A4AA6A8796D42C8EB5927AB1E@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 02:08 -0700, R, Durgadoss wrote:
> Hi Rui,
> 
> > -----Original Message-----
> > From: Zhang, Rui
> > Sent: Friday, February 08, 2013 2:35 PM
> > To: R, Durgadoss
> > Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> > Subject: Re: [PATCH 5/8] Thermal: Create Thermal map sysfs attributes for a
> > zone
> > 
> > On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> > > This patch creates a thermal map sysfs node under
> > > /sys/class/thermal/zoneX/. This contains
> > > entries named mapY_trip_type, mapY_sensor_name,
> > > mapY_cdev_name, mapY_trip_mask, mapY_weights.
> > sorry I still not quite understand.
> > 
> > does it look like?
> > /sys/class/thermal/zoneX/
> > |
> > map-->|-->map0_trip_type
> >       |...
> >       |-->map0_weight
> >       |-->map1_trip_type
> >       |...
> >       |-->map1_weight
> >       |...
> > 
> 
> There is no separate 'map' directory.
> So, everything is under /sys/class/thermal/zoneX/ directly,
> named as map0_weight etc...
> 
got it.

thanks,
rui

> I think I should make the Doc/ABI patch should clarify this.
> 
> Thanks,
> Durga


