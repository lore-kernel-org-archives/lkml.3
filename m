Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbbAHBEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:04:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:39246 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbbAHBEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:04:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,718,1413270000"; 
   d="scan'208";a="647885971"
Date: Wed, 7 Jan 2015 17:04:14 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: todd.e.brandt@linux.intel.com
Cc: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, david.woodhouse@intel.com,
        todd.e.brandt@intel.com
Subject: Re: [PATCH 1/3] mfd/axp20x: change battery cell name to fuel gauge
Message-ID: <20150107170414.27762fea@ultegra>
In-Reply-To: <20150107212450.GB3440@linux.intel.com>
References: <20150107212450.GB3440@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015 13:24:50 -0800
Todd E Brandt <todd.e.brandt@linux.intel.com> wrote:

> mfd/axp20x: change battery cell name to fuel gauge
> 
Acked-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

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
> @@ -236,7 +236,7 @@ static const struct i2c_device_id axp20x_i2c_id[]
> = { };
>  MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
>  
> -static const struct acpi_device_id axp20x_acpi_match[] = {
> +static struct acpi_device_id axp20x_acpi_match[] = {
>  	{
>  		.id = "INT33F4",
>  		.driver_data = AXP288_ID,
> @@ -350,9 +350,9 @@ static struct mfd_cell axp288_cells[] = {
>  		.resources = axp288_charger_resources,
>  	},
>  	{
> -		.name = "axp288_battery",
> -		.num_resources =
> ARRAY_SIZE(axp288_battery_resources),
> -		.resources = axp288_battery_resources,
> +		.name = "axp288_fuel_gauge",
> +		.num_resources =
> ARRAY_SIZE(axp288_fuel_gauge_resources),
> +		.resources = axp288_fuel_gauge_resources,
>  	},
>  	{
>  		.name = "axp288_pmic_acpi",

[Jacob Pan]
