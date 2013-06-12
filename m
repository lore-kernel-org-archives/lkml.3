Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3FLAwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:52:22 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47369 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3FLAwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:52:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1370442573-17512-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1370442573-17512-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130612005215.8816.58802@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: tegra: fix sclk_parents
Date: Tue, 11 Jun 2013 17:52:15 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-06-05 07:29:28)
> Use the correct parents for sclk according to the TRM.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Taken into clk-next.

Regards,
Mike

> ---
>  drivers/clk/tegra/clk-tegra114.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
> index 2774379e..758ba7d 100644
> --- a/drivers/clk/tegra/clk-tegra114.c
> +++ b/drivers/clk/tegra/clk-tegra114.c
> @@ -1735,7 +1735,7 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
>  }
>  
>  static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
> -                              "pll_p_out3", "pll_p_out2", "unused",
> +                              "pll_p", "pll_p_out2", "unused",
>                                "clk_32k", "pll_m_out1" };
>  
>  static const char *cclk_g_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
> -- 
> 1.7.7.rc0.72.g4b5ea.dirty
