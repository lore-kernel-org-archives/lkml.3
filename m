Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaBADND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:13:03 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:40875 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaBADMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:12:30 -0500
X-Auth-Info: RzkPH2A1CBcRuwjC8+0bNLxkenQP+5iyEqldawVXpKU=
From: Marek Vasut <marex@denx.de>
To: Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH 1/2] iio: add IIO_DISTANCE type
Date: Sat, 1 Feb 2014 04:01:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        matt.porter@linaro.org, koen@dominion.thruhere.net,
        pantelis.antoniou@gmail.com
References: <1391182703-2201-1-git-send-email-mranostay@gmail.com>
In-Reply-To: <1391182703-2201-1-git-send-email-mranostay@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201402010401.47894.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 31, 2014 at 04:38:22 PM, Matt Ranostay wrote:

The commit message is completely missing, it's entirely unclear what the 
intention of this patch is. Please write a commit message !

> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
> ---
>  drivers/iio/industrialio-core.c | 1 +
>  include/linux/iio/types.h       | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/iio/industrialio-core.c
> b/drivers/iio/industrialio-core.c index acc911a..ac999ab 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -70,6 +70,7 @@ static const char * const iio_chan_type_name_spec[] = {
>  	[IIO_CCT] = "cct",
>  	[IIO_PRESSURE] = "pressure",
>  	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
> +	[IIO_DISTANCE] = "distance",
>  };
> 
>  static const char * const iio_modifier_names[] = {
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 084d882..675c2d8 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -30,6 +30,7 @@ enum iio_chan_type {
>  	IIO_CCT,
>  	IIO_PRESSURE,
>  	IIO_HUMIDITYRELATIVE,
> +	IIO_DISTANCE,
>  };
> 
>  enum iio_modifier {

Best regards,
Marek Vasut
