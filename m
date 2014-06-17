Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965588AbaFQQpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:45:12 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:49777 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930AbaFQQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:45:08 -0400
Date: Tue, 17 Jun 2014 17:45:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 8/9] regulator: palmas: add driver data and modularize
 the probe
Message-ID: <20140617164502.GS29841@lee--X1>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
 <1401272423-25761-9-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401272423-25761-9-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> add driver data and modularize the probe.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  drivers/mfd/palmas.c                 |   42 +--
>  drivers/regulator/palmas-regulator.c |  656 ++++++++++++++++++++--------------
>  2 files changed, 395 insertions(+), 303 deletions(-)
> 
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c

[...]

> @@ -370,6 +334,8 @@ int palmas_ext_control_req_config(struct palmas *palmas,
>  	int bit_pos;
>  	int ret;
>  
> +	struct palmas_pmic_driver_data *pmic_ddata = palmas->pmic_ddata;
> +

Nit: I'd prefer the declarations to be grouped together, normally with
the struct defines above the ints etc.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
