Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbaKRVXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:23:25 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39892 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbaKRVXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:23:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-tegra@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1416312860-4446-2-git-send-email-tomeu.vizoso@collabora.com>
Cc: "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        "Mikko Perttunen" <mperttunen@nvidia.com>,
        "Tomeu Vizoso" <tomeu.vizoso@collabora.com>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Alexandre Courbot" <gnurou@gmail.com>, linux-kernel@vger.kernel.org
References: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
 <1416312860-4446-2-git-send-email-tomeu.vizoso@collabora.com>
Message-ID: <20141118212317.25314.65898@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 01/14] clk: tegra124: Remove old emc clock
Date: Tue, 18 Nov 2014 13:23:17 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tomeu Vizoso (2014-11-18 04:13:03)
> From: Mikko Perttunen <mperttunen@nvidia.com>
> 
> This clock has never been able to do anything.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Looks good to me.

Regards,
Mike

> 
> ---
> 
> v2:     * Don't remove emc_mux as it's being used by the MC clock now
> ---
>  drivers/clk/tegra/clk-tegra124.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
> index f5f9bac..07ec882 100644
> --- a/drivers/clk/tegra/clk-tegra124.c
> +++ b/drivers/clk/tegra/clk-tegra124.c
> @@ -790,7 +790,6 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
>         [tegra_clk_i2c2] = { .dt_id = TEGRA124_CLK_I2C2, .present = true },
>         [tegra_clk_uartc] = { .dt_id = TEGRA124_CLK_UARTC, .present = true },
>         [tegra_clk_mipi_cal] = { .dt_id = TEGRA124_CLK_MIPI_CAL, .present = true },
> -       [tegra_clk_emc] = { .dt_id = TEGRA124_CLK_EMC, .present = true },
>         [tegra_clk_usb2] = { .dt_id = TEGRA124_CLK_USB2, .present = true },
>         [tegra_clk_usb3] = { .dt_id = TEGRA124_CLK_USB3, .present = true },
>         [tegra_clk_vde_8] = { .dt_id = TEGRA124_CLK_VDE, .present = true },
> -- 
> 1.9.3
> 
