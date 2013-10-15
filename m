Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab3JOTnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:43:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42420 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab3JOTnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:43:07 -0400
Message-ID: <525D9AC7.5040800@wwwdotorg.org>
Date: Tue, 15 Oct 2013 13:43:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 19/19] clk: tegra30: move to common tegra clk infra
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-20-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-20-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:53 AM, Peter De Schrijver wrote:
> Move tegra30 to the common tegra clks.

Nit: Tegra30 not tegra30. Perhaps the same applies elsewhere?

> diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c

> +static struct tegra_clk tegra30_clks[tegra_clk_max] __initdata = {
> +	[tegra_clk_clk_32k] = { .dt_id = TEGRA30_CLK_CLK_32K, .present = true },
...
> +	[tegra_clk_pll_a_out0] = { .dt_id = TEGRA30_CLK_PLL_A_OUT0, .present = true },
>  
> -static unsigned int tegra30_get_pll_ref_div(void)
...
> -}
> +};

Nit: There's an extra blank line at the end of that table, which makes
the diff look a little odd.
