Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbbAANvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:51:23 -0500
Received: from mout.gmx.net ([212.227.15.18]:55154 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbbAANvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:51:20 -0500
Message-ID: <54A550CC.8030503@gmx.de>
Date: Thu, 01 Jan 2015 14:51:08 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 07/10] iio: imu: kmx61: Fix device initialization
 when setting trigger state
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-8-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-8-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:faaTdhfknnrr1jMuVMlk5LL9BmFGwl7M/xDXCr+h3nQYVAOVelo
 p3Q14NcbFLMyw7Kj5Sd5xakUfr0UzJ4x6P8Otu0jF764FFkoaFw16czQPnFqs+fB+Ebpgli
 +lnSTMVPIqpVaFQfkAfX+JVnKlswK7FJrS003JutrWz8UHHtLxC78GRUlWl9mDn7kEGWDlD
 Xiotndm8HKQa/8oq+mMAg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 23.12.2014 um 14:22:
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
>  drivers/iio/imu/kmx61.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 30825cf..5b5be2b 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -1057,8 +1057,7 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
>  		goto err_unlock;
>  	}
>  
> -
> -	if (data->acc_dready_trig == trig || data->motion_trig)
> +	if (data->acc_dready_trig == trig || data->motion_trig == trig)
>  		device = KMX61_ACC;
>  	else
>  		device = KMX61_MAG;
> 

