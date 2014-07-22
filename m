Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaGVLDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:03:52 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:49048 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbaGVLDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:03:48 -0400
Date: Tue, 22 Jul 2014 12:03:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v2 1/4] mfd: pm8xxx-spmi: add support for Qualcomm SPMI
 PMICs
Message-ID: <20140722110341.GE8406@lee--X1>
References: <1405613855-27572-1-git-send-email-svarbanov@mm-sol.com>
 <1405613855-27572-2-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405613855-27572-2-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Stanimir Varbanov wrote:

> From: Josh Cartwright <joshc@codeaurora.org>
> 
> The Qualcomm SPMI PMIC chips are components used with the
> Snapdragon 800 series SoC family.  This driver exists
> largely as a glue mfd component, it exists to be an owner
> of an SPMI regmap for children devices described in
> device tree.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>

Needs to be signed off by the author.

> ---
>  drivers/mfd/Kconfig       |   16 +++++++++++
>  drivers/mfd/Makefile      |    1 +
>  drivers/mfd/pm8xxx-spmi.c |   63 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/pm8xxx-spmi.c

[...]

> +++ b/drivers/mfd/pm8xxx-spmi.c
> @@ -0,0 +1,63 @@
> +/*
> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */

There should be a '\n' here.

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spmi.h>
> +#include <linux/regmap.h>
> +#include <linux/of_platform.h>

[...]

> +MODULE_DESCRIPTION("PM8XXX SPMI PMIC driver");
> +MODULE_ALIAS("platform:" KBUILD_MODNAME);
> +MODULE_AUTHOR("The Linux Foundation");

The Linux Foundation did not write this patch.

> +MODULE_LICENSE("GPL v2");

Appart from that:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
