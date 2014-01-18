Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaARLc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:32:27 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38119 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaARLcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:32:25 -0500
Message-ID: <52DA6657.6000206@kernel.org>
Date: Sat, 18 Jan 2014 11:32:39 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Marek Vasut <marex@denx.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] iio: mxs-lradc: remove useless scale_available files
References: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com> <1389628923-8689-4-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1389628923-8689-4-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13/01/14 16:02, Alexandre Belloni wrote:
> in_voltage8_scale_available and in_voltage9_scale_available are exposed to
> userspace but useless as in_voltage8_raw and in_voltage9_raw are not available.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Applied to the fixes-for-3.14new branch of iio.git

Thanks,
> ---
>   drivers/staging/iio/adc/mxs-lradc.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index 2289dc1bd928..cfd95d825702 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -1035,8 +1035,6 @@ SHOW_SCALE_AVAILABLE_ATTR(4);
>   SHOW_SCALE_AVAILABLE_ATTR(5);
>   SHOW_SCALE_AVAILABLE_ATTR(6);
>   SHOW_SCALE_AVAILABLE_ATTR(7);
> -SHOW_SCALE_AVAILABLE_ATTR(8);
> -SHOW_SCALE_AVAILABLE_ATTR(9);
>   SHOW_SCALE_AVAILABLE_ATTR(10);
>   SHOW_SCALE_AVAILABLE_ATTR(11);
>   SHOW_SCALE_AVAILABLE_ATTR(12);
> @@ -1053,8 +1051,6 @@ static struct attribute *mxs_lradc_attributes[] = {
>   	&iio_dev_attr_in_voltage5_scale_available.dev_attr.attr,
>   	&iio_dev_attr_in_voltage6_scale_available.dev_attr.attr,
>   	&iio_dev_attr_in_voltage7_scale_available.dev_attr.attr,
> -	&iio_dev_attr_in_voltage8_scale_available.dev_attr.attr,
> -	&iio_dev_attr_in_voltage9_scale_available.dev_attr.attr,
>   	&iio_dev_attr_in_voltage10_scale_available.dev_attr.attr,
>   	&iio_dev_attr_in_voltage11_scale_available.dev_attr.attr,
>   	&iio_dev_attr_in_voltage12_scale_available.dev_attr.attr,
>
