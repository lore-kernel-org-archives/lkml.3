Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3DXOwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:52:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:52494 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3DXOwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:52:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,542,1363158000"; 
   d="scan'208";a="231502080"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "amit.kachhap@linaro.org" <amit.kachhap@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 26/30] thermal: cpu_cooling: remove unused symbols
Thread-Topic: [PATCH 26/30] thermal: cpu_cooling: remove unused symbols
Thread-Index: AQHOO5AlJkL84SXMr0Ceyn4C7jlCT5jlf3bA
Date: Wed, 24 Apr 2013 14:52:27 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092632C9FCF@SHSMSX101.ccr.corp.intel.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
 <1366218743-20841-27-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1366218743-20841-27-git-send-email-eduardo.valentin@ti.com>
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
> Subject: [PATCH 26/30] thermal: cpu_cooling: remove unused symbols
> Importance: High
> 
> The list is needed so far. Thus removing it.
> 
s/needed/not needed?

Thanks,
rui
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/cpu_cooling.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c
> b/drivers/thermal/cpu_cooling.c index 3709274..825231f 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -38,11 +38,9 @@
>   * @cpufreq_val: integer value representing the absolute value of the
> clipped
>   *	frequency.
>   * @allowed_cpus: all the cpus involved for this
> cpufreq_cooling_device.
> - * @node: list_head to link all cpufreq_cooling_device together.
>   *
>   * This structure is required for keeping information of each
> - * cpufreq_cooling_device registered as a list whose head is
> represented by
> - * cooling_cpufreq_list. In order to prevent corruption of this list a
> + * cpufreq_cooling_device registered. In order to prevent corruption
> of
> + this a
>   * mutex lock cooling_cpufreq_lock is used.
>   */
>  struct cpufreq_cooling_device {
> @@ -51,9 +49,7 @@ struct cpufreq_cooling_device {
>  	unsigned int cpufreq_state;
>  	unsigned int cpufreq_val;
>  	struct cpumask allowed_cpus;
> -	struct list_head node;
>  };
> -static LIST_HEAD(cooling_cpufreq_list);  static
> DEFINE_IDR(cpufreq_idr);  static DEFINE_MUTEX(cooling_cpufreq_lock);
> 
> --
> 1.8.2.1.342.gfa7285d

