Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbbAANu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:50:28 -0500
Received: from mout.gmx.net ([212.227.15.18]:65060 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbbAANuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:50:25 -0500
Message-ID: <54A55094.6010800@gmx.de>
Date: Thu, 01 Jan 2015 14:50:12 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 06/10] iio: imu: kmx61: Use false instead of 0 for
 ev_enable_state
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-7-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-7-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:WMBOOUFGY6hTnyCfj+C/QUq1qMf3qnHAhBN8cPlVRP/BJ8rnEUT
 jLQxfFGTalmyZevU56HJmzZ3eocQK+0rHOUGt/n8EUr8WkLu1iozU5OehgI2lrNaXHf6sFM
 IxS5ENvZiJRZnwWwbx8WqwqpENQsvW2yx3GbR33B92rMa8nED9sCgTUbvUc3aq1HdRgEN3E
 GJ74kKBSJiZUZbMFbuZXQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 23.12.2014 um 14:22:
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
>  drivers/iio/imu/kmx61.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 332ee67..30825cf 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -976,7 +976,7 @@ static int kmx61_write_event_config(struct iio_dev *indio_dev,
>  	mutex_lock(&data->lock);
>  
>  	if (!state && data->motion_trig_on) {
> -		data->ev_enable_state = 0;
> +		data->ev_enable_state = false;
>  		goto err_unlock;
>  	}
>  
> 

