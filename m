Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3DXQcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:32:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:35011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab3DXQcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:32:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,542,1363158000"; 
   d="scan'208";a="291187573"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "amit.kachhap@linaro.org" <amit.kachhap@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 01/30] thermal: cpu_cooling: remove unused headers
Thread-Topic: [PATCH 01/30] thermal: cpu_cooling: remove unused headers
Thread-Index: AQHOO47ki7b2eZnfKUOG79VeKY3BmZjlmquA
Date: Wed, 24 Apr 2013 16:31:56 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092632CA053@SHSMSX101.ccr.corp.intel.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
 <1366218743-20841-2-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1366218743-20841-2-git-send-email-eduardo.valentin@ti.com>
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
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Eduardo Valentin
> Sent: Thursday, April 18, 2013 1:12 AM
> To: amit.kachhap@linaro.org
> Cc: Eduardo Valentin; Zhang, Rui; linux-pm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 01/30] thermal: cpu_cooling: remove unused headers
> Importance: High
> 
> As this code is not a module nor a platform device driver, this patch
> removes some unused header files.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/cpu_cooling.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c
> b/drivers/thermal/cpu_cooling.c index 5f5c780..778c43d 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -20,10 +20,7 @@
>   *
>   *
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~
>   */
> -#include <linux/kernel.h>
> -#include <linux/module.h>

This is still needed because of EXPORT_SYMBOL.
Or else, I get:
drivers/thermal/cpu_cooling.c:225:1: warning: data definition has no type or storage class [enabled by default]
drivers/thermal/cpu_cooling.c:225:1: warning: type defaults to int in declaration of EXPORT_SYMBOL_GPL [-Wimplicit-int]
drivers/thermal/cpu_cooling.c:225:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/thermal/cpu_cooling.c:479:1: warning: data definition has no type or storage class [enabled by default]
drivers/thermal/cpu_cooling.c:479:1: warning: type defaults to int in declaration of EXPORT_SYMBOL_GPL [-Wimplicit-int]
drivers/thermal/cpu_cooling.c:479:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/thermal/cpu_cooling.c:505:1: warning: data definition has no type or storage class [enabled by default]
drivers/thermal/cpu_cooling.c:505:1: warning: type defaults to int in declaration of EXPORT_SYMBOL_GPL [-Wimplicit-int]
drivers/thermal/cpu_cooling.c:505:1: warning: parameter names (without types) in function declaration [enabled by default]

thanks,
rui

>  #include <linux/thermal.h>
> -#include <linux/platform_device.h>
>  #include <linux/cpufreq.h>
>  #include <linux/err.h>
>  #include <linux/slab.h>
> --
> 1.8.2.1.342.gfa7285d
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
