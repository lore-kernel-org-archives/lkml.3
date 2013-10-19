Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3JSAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:16:27 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:51730 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3JSAQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <1382102719-5531-14-git-send-email-pdeschrijver@nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
	<1382102719-5531-14-git-send-email-pdeschrijver@nvidia.com>
Date: Fri, 18 Oct 2013 17:16:16 -0700
X-Google-Sender-Auth: dB-peKh7Mb5JymDZrr4_Lhbct88
Message-ID: <CAL1qeaEpemA5ekC2qzNfQKOkjAiWU3oYp4kwmdup1s1dOjAUNA@mail.gmail.com>
Subject: Re: [PATCH v5 13/15] clk: tegra: introduce common gen4 super clock
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> +#define PLL_BASE_LOCK BIT(27)
> +#define PLL_MISC_LOCK_ENABLE 18

I don't see these used anywhere.

> +static const char *cclk_lp_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
> +                                        "pll_p", "pll_p_out4", "unused",
> +                                        "unused", "pll_x", "pll_x_out0" };

nit: insert blank line here.

> +static void __init tegra_sclk_init(void __iomem *clk_base,
> +                               struct tegra_clk *tegra_clks)
> +{

Thanks,
Andrew
