Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbbATLre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:47:34 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65409 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbATLrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:47:32 -0500
Date: Tue, 20 Jan 2015 11:47:25 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Todd E Brandt <todd.e.brandt@linux.intel.com>
Cc: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        sameo@linux.intel.com, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, david.woodhouse@intel.com,
        todd.e.brandt@intel.com
Subject: Re: [PATCH 1/3] mfd/axp20x: change battery cell name to fuel gauge
Message-ID: <20150120114725.GI13701@x1>
References: <20150107212450.GB3440@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150107212450.GB3440@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jan 2015, Todd E Brandt wrote:

> mfd/axp20x: change battery cell name to fuel gauge
> 
> Name changes to the battery cell structure to a
> more generic cell type: fuel gauge.
> 
> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> ----
>  drivers/mfd/axp20x.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> index b1b580a..e75717e 100644
> --- a/drivers/mfd/axp20x.c
> +++ b/drivers/mfd/axp20x.c
> @@ -87,7 +87,7 @@ static struct resource axp20x_pek_resources[] = {
>  	},
>  };
>  
> -static struct resource axp288_battery_resources[] = {
> +static struct resource axp288_fuel_gauge_resources[] = {
>  	{
>  		.start = AXP288_IRQ_QWBTU,
>  		.end   = AXP288_IRQ_QWBTU,
> @@ -236,7 +236,7 @@ static const struct i2c_device_id axp20x_i2c_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
>  
> -static const struct acpi_device_id axp20x_acpi_match[] = {
> +static struct acpi_device_id axp20x_acpi_match[] = {

Why have you dropped the cost qualifier here?

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
