Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3JJIzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:55:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:19273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab3JJIzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:55:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="scan'208";a="414745057"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Abelardo Ricart <aricart@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Thermal: Fix Step-wise governor Kconfig help text
Thread-Topic: [PATCH] Thermal: Fix Step-wise governor Kconfig help text
Thread-Index: AQHOxMygforfDkHU+0KBMSMG7WcYapntotQg
Date: Thu, 10 Oct 2013 08:55:11 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926301185773@SHSMSX101.ccr.corp.intel.com>
References: <1381308587-25460-1-git-send-email-aricart@gmail.com>
In-Reply-To: <1381308587-25460-1-git-send-email-aricart@gmail.com>
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

Hi, Abelardo,

> -----Original Message-----
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Abelardo Ricart
> Sent: Wednesday, October 09, 2013 4:50 PM
> To: linux-pm@vger.kernel.org
> Cc: trivial@kernel.org; linux-kernel@vger.kernel.org; Abelardo Ricart
> Subject: [PATCH] Thermal: Fix Step-wise governor Kconfig help text
> 
> Trivial fix for the help text of THERMAL_GOV_STEP_WISE.
> 
> Signed-off-by: Abelardo Ricart <aricart@gmail.com>

Thanks for your patch, but we've already have a fix here
https://patchwork.kernel.org/patch/2956561/

thanks,
rui
> ---
>  drivers/thermal/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig index
> dbfc390..29007bd 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -69,6 +69,7 @@ config THERMAL_GOV_STEP_WISE
>  	bool "Step_wise thermal governor"
>  	help
>  	  Enable this to manage platform thermals using a simple linear
> +	  throttling algorithm.
> 
>  config THERMAL_GOV_USER_SPACE
>  	bool "User_space thermal governor"
> --
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
