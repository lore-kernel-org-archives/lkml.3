Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbbAANsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:48:05 -0500
Received: from mout.gmx.net ([212.227.15.19]:51505 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbbAANsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:48:03 -0500
Message-ID: <54A55005.3080108@gmx.de>
Date: Thu, 01 Jan 2015 14:47:49 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 04/10] iio: imu: kmx61: Fixup parameters alignment
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-5-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-5-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:HPGflwC3ad8yWlnzjN5cJNK1gGbXbUqHgLUysfT6kKo/xrjksOl
 iQUKeHorz5w3jJPrUbb3CIT2Kxh4uVoifEz99Fu8NtfRu5ajoGr4UWNlGr2nEB7ORdpSgI9
 LsVmZ6HybCuklvMNjuITlR2Y1fUYTeQ4as/vg7fL/323jB3eQffswrUDb1h5o4ac+xiXlge
 WECxFNyOfoy9XoK2AOAKg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 23.12.2014 um 14:22:
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
>  drivers/iio/imu/kmx61.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 4fc4f63..2652179 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -926,11 +926,11 @@ static int kmx61_read_event(struct iio_dev *indio_dev,
>  }
>  
>  static int kmx61_write_event(struct iio_dev *indio_dev,
> -			    const struct iio_chan_spec *chan,
> -			    enum iio_event_type type,
> -			    enum iio_event_direction dir,
> -			    enum iio_event_info info,
> -			    int val, int val2)
> +			     const struct iio_chan_spec *chan,
> +			     enum iio_event_type type,
> +			     enum iio_event_direction dir,
> +			     enum iio_event_info info,
> +			     int val, int val2)
>  {
>  	struct kmx61_data *data = kmx61_get_data(indio_dev);
>  
> @@ -962,10 +962,10 @@ static int kmx61_read_event_config(struct iio_dev *indio_dev,
>  }
>  
>  static int kmx61_write_event_config(struct iio_dev *indio_dev,
> -				   const struct iio_chan_spec *chan,
> -				   enum iio_event_type type,
> -				   enum iio_event_direction dir,
> -				   int state)
> +				    const struct iio_chan_spec *chan,
> +				    enum iio_event_type type,
> +				    enum iio_event_direction dir,
> +				    int state)
>  {
>  	struct kmx61_data *data = kmx61_get_data(indio_dev);
>  	int ret = 0;
> 

