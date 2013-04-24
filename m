Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab3DXOuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:50:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:8527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab3DXOuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:50:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,542,1363158000"; 
   d="scan'208";a="300586040"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "amit.kachhap@linaro.org" <amit.kachhap@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 04/30] thermal: cpu_cooling: use EXPORT_SYMBOL_GPL
Thread-Topic: [PATCH 04/30] thermal: cpu_cooling: use EXPORT_SYMBOL_GPL
Thread-Index: AQHOO48NzzGzTGBrE0S0JiRIjfCm5Zjlfunw
Date: Wed, 24 Apr 2013 14:50:18 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092632C9FA4@SHSMSX101.ccr.corp.intel.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
 <1366218743-20841-5-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1366218743-20841-5-git-send-email-eduardo.valentin@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

Thanks,
rui

> -----Original Message-----
> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> Sent: Thursday, April 18, 2013 1:12 AM
> To: amit.kachhap@linaro.org
> Cc: Eduardo Valentin; Zhang, Rui; linux-pm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 04/30] thermal: cpu_cooling: use EXPORT_SYMBOL_GPL
> Importance: High
> 
> Restrict the usage to GPL modules.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/cpu_cooling.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c
> b/drivers/thermal/cpu_cooling.c index 7c0c05b..64dc4dd 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -200,8 +200,7 @@ unsigned long cpufreq_cooling_get_level(unsigned
> int cpu, unsigned int freq)
>  		return THERMAL_CSTATE_INVALID;
>  	return (unsigned long)val;
>  }
> -
> -EXPORT_SYMBOL(cpufreq_cooling_get_level);
> +EXPORT_SYMBOL_GPL(cpufreq_cooling_get_level);
> 
>  /**
>   * get_cpu_frequency - get the absolute value of frequency from level.
> @@ -414,7 +413,7 @@ struct thermal_cooling_device
> *cpufreq_cooling_register(
>  	mutex_unlock(&cooling_cpufreq_lock);
>  	return cool_dev;
>  }
> -EXPORT_SYMBOL(cpufreq_cooling_register);
> +EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
> 
>  /**
>   * cpufreq_cooling_unregister - function to remove cpufreq cooling
> device.
> @@ -438,4 +437,4 @@ void cpufreq_cooling_unregister(struct
> thermal_cooling_device *cdev)
>  	release_idr(&cpufreq_idr, cpufreq_dev->id);
>  	kfree(cpufreq_dev);
>  }
> -EXPORT_SYMBOL(cpufreq_cooling_unregister);
> +EXPORT_SYMBOL_GPL(cpufreq_cooling_unregister);
> --
> 1.8.2.1.342.gfa7285d

