Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaGQKsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:48:08 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:47112 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaGQKsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:48:05 -0400
MIME-Version: 1.0
In-Reply-To: <1404834869-23049-2-git-send-email-svarbanov@mm-sol.com>
References: <1404834869-23049-1-git-send-email-svarbanov@mm-sol.com>
	<1404834869-23049-2-git-send-email-svarbanov@mm-sol.com>
Date: Thu, 17 Jul 2014 16:18:02 +0530
Message-ID: <CAMf-jSk5+c1QYfKfjqmstB60bM3adK5tgAYwmPKhOi6cSeM_WA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: qpnp-spmi: add support for Qualcomm QPNP PMICs
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Mark Brown
Hi Josh/Stanimir,


On Tue, Jul 8, 2014 at 9:24 PM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
> From: Josh Cartwright <joshc@codeaurora.org>
>
> The Qualcomm QPNP PMIC chips are components used with the
> Snapdragon 800 series SoC family.  This driver exists
.
[SNIP]
.
> +config MFD_QPNP_SPMI
> +       tristate "Qualcomm QPNP SPMI PMIC"
> +       depends on ARCH_QCOM || COMPILE_TEST
> +       depends on OF
> +       select MFD_CORE
> +       select REGMAP_SPMI
REGMAP_SPMI use SPMI functions.

https://patchwork.kernel.org/patch/4566591/

> +       help
> +         This enables support for the Qualcomm QPNP SPMI PMICs.
> +         These PMICs are currently used with the Snapdragon 800 series of
> +         SoCs.  Note, that this will only be useful paired with descriptions
.
[snip]
.
> +
> +MODULE_DESCRIPTION("QPNP PMIC SPMI driver");
> +MODULE_ALIAS("platform:" KBUILD_MODNAME);
> +MODULE_AUTHOR("The Linux Foundation");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
