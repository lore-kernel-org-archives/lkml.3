Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764799Ab3DDUZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:25:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40852 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764145Ab3DDUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:25:09 -0400
Message-ID: <515DE192.1030408@ti.com>
Date: Thu, 4 Apr 2013 16:24:50 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.daniel@samsung.com>, <durgadoss.r@intel.com>, <andi@lisas.de>,
        <eduardo.valentin@ti.com>
Subject: Re: [PATCH V2 1/3] Thermal: rename thermal_sys.c to thermal_core.c
References: <1364567196-3560-1-git-send-email-rui.zhang@intel.com> <1364567196-3560-2-git-send-email-rui.zhang@intel.com>
In-Reply-To: <1364567196-3560-2-git-send-email-rui.zhang@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-03-2013 10:26, Zhang Rui wrote:
> this is the preparation work to build all the thermal core framework
> source file, like governors, cpu cooling, etc, into one module.
>
> No functional change in this patch.
>
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Durga and me have already reviewed and acked this patch. Can you please 
add our Acked-by on this patch?

> ---
>   drivers/thermal/Makefile                          |    1 +
>   drivers/thermal/{thermal_sys.c => thermal_core.c} |    0
>   2 files changed, 1 insertion(+)
>   rename drivers/thermal/{thermal_sys.c => thermal_core.c} (100%)
>
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index d3a2b38..b2009bd 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -3,6 +3,7 @@
>   #
>
>   obj-$(CONFIG_THERMAL)		+= thermal_sys.o
> +thermal_sys-y			+= thermal_core.o
>
>   # governors
>   obj-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_core.c
> similarity index 100%
> rename from drivers/thermal/thermal_sys.c
> rename to drivers/thermal/thermal_core.c
>

