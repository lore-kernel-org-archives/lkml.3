Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3IYOZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:25:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:14494 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab3IYOZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:25:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,978,1371106800"; 
   d="scan'208";a="406984286"
Message-ID: <1380119126.4879.0.camel@rzhang1-mobl4>
Subject: Re: [PATCH] typo in drivers/thermal/Kconfig: lpatform instead of
 platform
From: Zhang Rui <rui.zhang@intel.com>
To: Regid Ichira <regid23@nt1.in>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Sep 2013 22:25:26 +0800
In-Reply-To: <20130908215853.GD8821@nt1.in>
References: <20130908215853.GD8821@nt1.in>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 00:58 +0300, Regid Ichira wrote:
> Applied to the HEAD of linux.git,
>                        VERSION = 3 PATCHLEVEL = 11 SUBLEVEL = 0
> Signed-off-by: Regid Ichira <regid23@nt1.in>

applied to thermal -next.

thanks,
rui
> ---
>  drivers/thermal/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index e988c81..3f99f79 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -47,7 +47,7 @@ config THERMAL_DEFAULT_GOV_USER_SPACE
>  	select THERMAL_GOV_USER_SPACE
>  	help
>  	  Select this if you want to let the user space manage the
> -	  lpatform thermals.
> +	  platform thermals.
>  
>  endchoice
>  


