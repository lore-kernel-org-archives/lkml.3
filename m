Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaDKEB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:01:57 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35965 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDKEBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <1397124377-16969-2-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
	<1397124377-16969-2-git-send-email-cw00.choi@samsung.com>
Date: Fri, 11 Apr 2014 09:31:54 +0530
Message-ID: <CAK9yfHzWvddP_A_Vta3kzS4q0=dU3LJwWRu_CwCwsHJSfieihQ@mail.gmail.com>
Subject: Re: [PATCH 10/27] ARM: dts: exynos3250: Add new exynos3250.dtsi file
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 10 April 2014 15:36, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> From: Tomasz Figa <t.figa@samsung.com>
>
> This patch add new exynos3250.dtsi to support Exynos3250 SoC and includes
> chipid/sys_reg dt node.
>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250.dtsi | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
>
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> new file mode 100644
> index 0000000..3c8cee6
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -0,0 +1,34 @@
> +/*
> + * Samsung's Exynos3250 SoC device tree source
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * Samsung's Exynos3250 SoC device nodes are listed in this file. Exynos3250
> + * based board files can include this file and provide values for board specfic
> + * bindings.
> + *
> + * Note: This file does not include device nodes for all the controllers in
> + * Exynos3250 SoC. As device tree coverage for Exynos3250 increases, additional
> + * nodes can be added to this file.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "skeleton.dtsi"
> +
> +/ {
> +       compatible = "samsung,exynos3250";
> +
> +       chipid@10000000 {
> +               compatible = "samsung,exynos4210-chipid";
> +               reg = <0x10000000 0x100>;
> +       };
> +
> +       sys_reg: syscon@10010000 {
> +               compatible = "samsung,exynos3-sysreg", "syscon";
> +               reg = <0x10010000 0x400>;
> +       };
> +};

Shouldn't these be grouped under the soc node?

-- 
With warm regards,
Sachin
