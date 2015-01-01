Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbbAANp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:45:28 -0500
Received: from mout.gmx.net ([212.227.15.15]:61602 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbbAANp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:45:26 -0500
Message-ID: <54A54F6B.1010307@gmx.de>
Date: Thu, 01 Jan 2015 14:45:15 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 01/10] iio: imu: kmx61: Save odr_bits for later use
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-2-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-2-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:1nGpsydCfqg0asjz8VOXMXdjvke6noGIFPOXpaomCQlYDl+YCkc
 ZY05hm7WjqdDiPF7SgAiWqSytad4L0+LJGBKuQFyPh6SIvpO6WuMWK5e5RTxtIZyrbmFGZc
 BqpuSHJljPHkFO3VqaLuGGWh488Jw36Lnj+W8YO2VVVr7GmeBDek+YHbS/XteGqVq3Kz6aw
 4rJlmvOJ28d9LVbxXhznA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 23.12.2014 um 14:22:
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
>  drivers/iio/imu/kmx61.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 972424b..fe0cee7 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -465,6 +465,8 @@ static int kmx61_set_odr(struct kmx61_data *data, int val, int val2, u8 device)
>  	if (ret < 0)
>  		return ret;
>  
> +	data->odr_bits = odr_bits;
> +
>  	if (device & KMX61_ACC) {
>  		ret = kmx61_set_wake_up_odr(data, val, val2);
>  		if (ret)
> 

