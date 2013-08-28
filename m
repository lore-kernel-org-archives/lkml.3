Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3H1G14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:27:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25655 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3H1G1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:27:54 -0400
X-AuditID: cbfee68e-b7f756d000004512-ee-521d9868d101
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
In-reply-to: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
Subject: Re: [PATCH 1/5] mfd: asic3: Remove .set_pwr() callback
Date: Wed, 28 Aug 2013 15:27:51 +0900
Message-id: <000001cea3b7$b9334250$2b99c6f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6jssAlip17A5gXTNKNBqRYWYD+6gABGj7w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zQ92MGbJBBme/Slpsf72RzeL9xnlM
	FvuanrNYXF54idViYtMdFov7X48yWlzeNYfN4nQ3qwOHx9/n11k8PnyM85jdMZPV49CVtYwe
	d67tYfOYdzLQo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDLuNZxlL+gUrNj6dh9jA+NX3i5G
	Dg4JAROJvltpXYycQKaYxIV769lAbCGBZYwSHe+YIOImEjdXgdhcQPHpjBKbJu9gh3B+MUrc
	+XWHEaSKTUBN4suXw+wgtohAvkTTwknMIEXMAs8YJW5fvcQOMdZW4mxvKwuIzSlgJ3Gi/SZY
	s7CAvcSSd21gNSwCqhJb5t1hBbF5gepnv5jCCGELSvyYfA+sl1lAS2L9zuNMELa8xOY1b5kh
	vlGXePRXF+IGI4mPC/9ClYtI7HvxjhHkHgmBVg6JgwteMkHsEpD4NvkQC0SvrMSmA8wQH0tK
	HFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kpFecmFtcmpeul5yfu4kREt99
	OxhvHrA+xJgMtH4is5Rocj4wPeSVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgTFTIeerTs8n1Z/xdqu/M25n4dBccvPpj0c/T+/SXKa0xWZruRf7
	+7ttDpOVNzO+Z7H7x/d3yyLXxwuFGF9+uHSZ9VXh3HV87/6UL9r0OPvHjbmSD0S0lSpUs1Y5
	GBx8HDF1pf03oZycny3XBZz3y81JYJ165fjEppl3zjO6m0y2XntF8tyPKOmbSizFGYmGWsxF
	xYkAyCa5bQUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQd2MGbJBBv8fi1hsf72RzeL9xnlM
	FvuanrNYXF54idViYtMdFov7X48yWlzeNYfN4nQ3qwOHx9/n11k8PnyM85jdMZPV49CVtYwe
	d67tYfOYdzLQo2/LKkaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFm3Gs4y17QKVix9e0+xgbGr7xdjJwcEgImEjdXvWOCsMUkLtxbz9bFyMUhJDCdUWLT5B3s
	EM4vRok7v+4wglSxCahJfPlymB3EFhHIl2haOIkZpIhZ4BmjxO2rl8ASQgK2Emd7W1lAbE4B
	O4kT7TfBmoUF7CWWvGsDq2ERUJXYMu8OK4jNC1Q/+8UURghbUOLH5HtgvcwCWhLrdx5ngrDl
	JTaveQu0jAPoVHWJR391IW4wkvi48C9UuYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR
	1ILkguKk9FxDveLE3OLSvHS95PzcTYzgBPJMagfjygaLQ4wCHIxKPLwWm2WChFgTy4orcw8x
	SnAwK4nwlvwHCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MLnllcQbGpuYGVkamVkYmZib
	kyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANj1apguR0nMg//VXN5UrlIlEmL/Qurr8K/
	Kdmcr001503tCrp6+YLPuX4l7UlnKzzZ5X1Wz8g4cn/FeodkXgvfsyuT0zcu0I1MYGYoCRV5
	Uj1t5mPV2Z+qShKu3lPqrT+Qpv9I5pKMd8/O4hmqlnPlLTsTOK/aPZdc/jv5yadtQm81J/+/
	w6WoxFKckWioxVxUnAgAGZGUB2QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 28, 2013 2:52 PM, Jingoo Han wrote:
> 
> Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
> platform data", .set_pwr() callback is removed from platform data.
> Thus, .set_pwr() is not used anymore. Also, this patch fixes
> the following build error and warning.

I made this patch based on linux-next tree.

However, commit 3af9d15 "mmc: tmio-mmc: Remove .set_pwr()
Callback from platform data" was merged to mmc-next tree.

Thus, how about merging these patchset through mmc-next tree
instead of mfd tree?

Best regards,
Jingoo Han

> 
> drivers/mfd/asic3.c:724:2: error: unknown field 'set_pwr' specified in initializer
> drivers/mfd/asic3.c:724:2: warning: initialization makes integer from pointer without a cast [enabled
> by default]
> drivers/mfd/asic3.c:724:2: warning: (near initialization for 'asic3_mmc_data.capabilities' [enabled by
> default]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Ian Molton <ian.molton@collabora.co.uk>
> Cc: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mfd/asic3.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index fa22154..7a6f713 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -705,13 +705,6 @@ static struct mfd_cell asic3_cell_ds1wm = {
>  	.resources     = ds1wm_resources,
>  };
> 
> -static void asic3_mmc_pwr(struct platform_device *pdev, int state)
> -{
> -	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
> -
> -	tmio_core_mmc_pwr(asic->tmio_cnf, 1 - asic->bus_shift, state);
> -}
> -
>  static void asic3_mmc_clk_div(struct platform_device *pdev, int state)
>  {
>  	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
> @@ -721,7 +714,6 @@ static void asic3_mmc_clk_div(struct platform_device *pdev, int state)
> 
>  static struct tmio_mmc_data asic3_mmc_data = {
>  	.hclk           = 24576000,
> -	.set_pwr        = asic3_mmc_pwr,
>  	.set_clk_div    = asic3_mmc_clk_div,
>  };
> 
> --
> 1.7.10.4


