Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3INQxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:53:06 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43231 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3INQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:53:03 -0400
Message-ID: <5234A28D.1030409@kernel.org>
Date: Sat, 14 Sep 2013 18:53:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 38/38] iio: magn-core: st: Provide support for the LSM303DLH
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-39-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378817379-8238-39-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 13:49, Lee Jones wrote:
> Trivial patch adding the LSM303DLH to the list of already supported
> Magnetometer Sensors.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
err.
> index 12e7e79..b2e2917 100644
> --- a/drivers/iio/magnetometer/st_magn_core.c
> +++ b/drivers/iio/magnetometer/st_magn_core.c
> @@ -151,7 +151,8 @@ static const struct st_sensors st_magn_sensors[] = {
>  		.wai = ST_MAGN_1_WAI_EXP,
>  		.sensors_supported = {
>  			[0] = LSM303DLHC_MAGN_DEV_NAME,
> -			[1] = LSM303DLM_MAGN_DEV_NAME,
> +			[1] = LSM303DLH_MAGN_DEV_NAME,
> +			[0] = LSM303DLM_MAGN_DEV_NAME,
[2]?
>  		},
>  		.ch = (struct iio_chan_spec *)st_magn_16bit_channels,
>  		.odr = {
> 
