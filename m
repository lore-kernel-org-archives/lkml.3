Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946195Ab3BHJIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 04:08:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:63742 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759968Ab3BHJIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 04:08:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="284392389"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 5/8] Thermal: Create Thermal map sysfs attributes for a
 zone
Thread-Topic: [PATCH 5/8] Thermal: Create Thermal map sysfs attributes for a
 zone
Thread-Index: AQHOA47i5i8tlW0VJUy3orbfk+VWFphvU0oAgABcxzA=
Date: Fri, 8 Feb 2013 09:08:34 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5927AB1E@BGSMSX101.gar.corp.intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
	 <1360061183-14137-6-git-send-email-durgadoss.r@intel.com>
 <1360314270.2242.45.camel@rzhang1-mobl4>
In-Reply-To: <1360314270.2242.45.camel@rzhang1-mobl4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1898n0k002613

Hi Rui,

> -----Original Message-----
> From: Zhang, Rui
> Sent: Friday, February 08, 2013 2:35 PM
> To: R, Durgadoss
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 5/8] Thermal: Create Thermal map sysfs attributes for a
> zone
> 
> On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> > This patch creates a thermal map sysfs node under
> > /sys/class/thermal/zoneX/. This contains
> > entries named mapY_trip_type, mapY_sensor_name,
> > mapY_cdev_name, mapY_trip_mask, mapY_weights.
> sorry I still not quite understand.
> 
> does it look like?
> /sys/class/thermal/zoneX/
> |
> map-->|-->map0_trip_type
>       |...
>       |-->map0_weight
>       |-->map1_trip_type
>       |...
>       |-->map1_weight
>       |...
> 

There is no separate 'map' directory.
So, everything is under /sys/class/thermal/zoneX/ directly,
named as map0_weight etc...

I think I should make the Doc/ABI patch should clarify this.

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
