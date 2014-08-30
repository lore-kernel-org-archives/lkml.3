Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaH3KDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:03:07 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60607 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaH3KDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:03:04 -0400
Message-ID: <5401A154.8020102@kernel.org>
Date: Sat, 30 Aug 2014 11:03:00 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Derek Basehore <dbasehore@chromium.org>,
        Teodora Baluta <teodora.baluta@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: iio: light: isl29018: fix typo
References: <1409322382-30021-1-git-send-email-laurentiu.palcu@intel.com> <1409322382-30021-2-git-send-email-laurentiu.palcu@intel.com>
In-Reply-To: <1409322382-30021-2-git-send-email-laurentiu.palcu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 15:26, Laurentiu Palcu wrote:
> isl29108 was used, instead of isl29018.
> 
> Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
Applied to the togreg branch of iio.git - initially pushed out as testing for the
autobuilders to play.

Thanks,

Jonathan
> ---
>  drivers/staging/iio/light/isl29018.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index 86cc8f9..63c70be 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -447,7 +447,7 @@ static struct attribute *isl29018_attributes[] = {
>  	NULL
>  };
>  
> -static const struct attribute_group isl29108_group = {
> +static const struct attribute_group isl29018_group = {
>  	.attrs = isl29018_attributes,
>  };
>  
> @@ -510,8 +510,8 @@ static int isl29018_chip_init(struct isl29018_chip *chip)
>  	return 0;
>  }
>  
> -static const struct iio_info isl29108_info = {
> -	.attrs = &isl29108_group,
> +static const struct iio_info isl29018_info = {
> +	.attrs = &isl29018_group,
>  	.driver_module = THIS_MODULE,
>  	.read_raw = &isl29018_read_raw,
>  	.write_raw = &isl29018_write_raw,
> @@ -579,7 +579,7 @@ static int isl29018_probe(struct i2c_client *client,
>  	if (err)
>  		return err;
>  
> -	indio_dev->info = &isl29108_info;
> +	indio_dev->info = &isl29018_info;
>  	indio_dev->channels = isl29018_channels;
>  	indio_dev->num_channels = ARRAY_SIZE(isl29018_channels);
>  	indio_dev->name = id->name;
> 
