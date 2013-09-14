Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3INLO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 07:14:28 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40566 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3INLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 07:14:27 -0400
Message-ID: <52345330.4050707@kernel.org>
Date: Sat, 14 Sep 2013 13:14:40 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 14/38] iio: accel: st: Append _accel to accelerator sensor
 device names
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-15-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378817379-8238-15-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 13:49, Lee Jones wrote:
> Some of ST's sensors are appended with their sensor type and some
> are not. For consistency we're extending the same naming convention
> throughout.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Honestly I don't care either way on these, but consistency would definitely
be good so applied to the togreg branch of iio.git

Thanks,
> ---
>  drivers/iio/accel/st_accel.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/accel/st_accel.h b/drivers/iio/accel/st_accel.h
> index c387763..d8d22e5 100644
> --- a/drivers/iio/accel/st_accel.h
> +++ b/drivers/iio/accel/st_accel.h
> @@ -15,11 +15,11 @@
>  #include <linux/iio/common/st_sensors.h>
>  
>  #define LSM303DLHC_ACCEL_DEV_NAME	"lsm303dlhc_accel"
> -#define LIS3DH_ACCEL_DEV_NAME		"lis3dh"
> +#define LIS3DH_ACCEL_DEV_NAME		"lis3dh_accel"
>  #define LSM330D_ACCEL_DEV_NAME		"lsm330d_accel"
>  #define LSM330DL_ACCEL_DEV_NAME		"lsm330dl_accel"
>  #define LSM330DLC_ACCEL_DEV_NAME	"lsm330dlc_accel"
> -#define LIS331DLH_ACCEL_DEV_NAME	"lis331dlh"
> +#define LIS331DLH_ACCEL_DEV_NAME	"lis331dlh_accel"
>  #define LSM303DL_ACCEL_DEV_NAME		"lsm303dl_accel"
>  #define LSM303DLH_ACCEL_DEV_NAME	"lsm303dlh_accel"
>  #define LSM303DLM_ACCEL_DEV_NAME	"lsm303dlm_accel"
> 
