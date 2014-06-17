Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506AbaFQQdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:33:09 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:62894 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965093AbaFQQdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:33:06 -0400
Date: Tue, 17 Jun 2014 17:32:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 5/9] regulator: palmas: Shift the reg_info structure
 definition to the header file
Message-ID: <20140617163259.GP29841@lee--X1>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
 <1401272423-25761-6-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401272423-25761-6-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Keerthy wrote:

> Shift the reg_info structure definition to the header file.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  drivers/regulator/palmas-regulator.c |    9 ---------
>  include/linux/mfd/palmas.h           |    9 +++++++++
>  2 files changed, 9 insertions(+), 9 deletions(-)

Patch looks fine.  I guess we'll wait and pull the entire set in once
it's ready.

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 9602eba..d41f3de 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -27,15 +27,6 @@
>  #include <linux/of_platform.h>
>  #include <linux/regulator/of_regulator.h>
>  
> -struct regs_info {
> -	char	*name;
> -	char	*sname;
> -	u8	vsel_addr;
> -	u8	ctrl_addr;
> -	u8	tstep_addr;
> -	int	sleep_id;
> -};
> -
>  static const struct regulator_linear_range smps_low_ranges[] = {
>  	REGULATOR_LINEAR_RANGE(500000, 0x1, 0x6, 0),
>  	REGULATOR_LINEAR_RANGE(510000, 0x7, 0x79, 10000),
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 52a24a9..150a6314 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -88,6 +88,15 @@ struct palmas {
>  	u8 pwm_muxed;
>  };
>  
> +struct regs_info {
> +	char	*name;
> +	char	*sname;
> +	u8	vsel_addr;
> +	u8	ctrl_addr;
> +	u8	tstep_addr;
> +	int	sleep_id;
> +};
> +
>  struct palmas_gpadc_platform_data {
>  	/* Channel 3 current source is only enabled during conversion */
>  	int ch3_current;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
