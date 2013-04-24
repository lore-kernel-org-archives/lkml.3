Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab3DXOuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:50:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:51355 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab3DXOuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,542,1363158000"; 
   d="scan'208";a="300585825"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "amit.kachhap@linaro.org" <amit.kachhap@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 03/30] thermal: cpu_cooling: fix kernel_doc for
 cpufreq_cooling_device
Thread-Topic: [PATCH 03/30] thermal: cpu_cooling: fix kernel_doc for
 cpufreq_cooling_device
Thread-Index: AQHOO48GXM16rU9320ePjNjK3BhIX5jlfsRw
Date: Wed, 24 Apr 2013 14:49:59 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092632C9F91@SHSMSX101.ccr.corp.intel.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
 <1366218743-20841-4-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1366218743-20841-4-git-send-email-eduardo.valentin@ti.com>
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



> -----Original Message-----
> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> Sent: Thursday, April 18, 2013 1:12 AM
> To: amit.kachhap@linaro.org
> Cc: Eduardo Valentin; Zhang, Rui; linux-pm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 03/30] thermal: cpu_cooling: fix kernel_doc for
> cpufreq_cooling_device
> Importance: High
> 
> Simple fixes for making kernel_doc happy about struct
> cpufreq_cooling_device. Includes also a minor spelling fix.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Applied.

Thanks,
rui
> ---
>  drivers/thermal/cpu_cooling.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c
> b/drivers/thermal/cpu_cooling.c index d0d6a0c..7c0c05b 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -28,11 +28,11 @@
>  #include <linux/cpu_cooling.h>
> 
>  /**
> - * struct cpufreq_cooling_device
> + * struct cpufreq_cooling_device - data for cooling device with
> cpufreq
>   * @id: unique integer value corresponding to each
> cpufreq_cooling_device
>   *	registered.
> - * @cool_dev: thermal_cooling_device pointer to keep track of the the
> - *	egistered cooling device.
> + * @cool_dev: thermal_cooling_device pointer to keep track of the
> + *	registered cooling device.
>   * @cpufreq_state: integer value representing the current state of
> cpufreq
>   *	cooling	devices.
>   * @cpufreq_val: integer value representing the absolute value of the
> clipped
> --
> 1.8.2.1.342.gfa7285d

