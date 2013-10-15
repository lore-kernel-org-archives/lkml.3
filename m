Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab3JOUVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:21:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35851 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122Ab3JOUVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:21:38 -0400
Message-ID: <525DA3CF.4020900@wwwdotorg.org>
Date: Tue, 15 Oct 2013 14:21:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 4/7] clk: tegra124: Add new peripheral clocks
References: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com> <1381850098-12357-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381850098-12357-5-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 09:14 AM, Peter De Schrijver wrote:
> Tegra124 introduces a number of new peripheral clocks. This patch adds those
> to the common peripheral clock code.

> diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c

> @@ -453,6 +501,12 @@ static struct tegra_periph_init_data gate_clks[] = {
>  	GATE("dsib", "dsib_mux", 82, 0, tegra_clk_dsib, 0),
>  	GATE("emc", "emc_mux", 57, 0, tegra_clk_emc, CLK_IGNORE_UNUSED),
>  	GATE("sata_cold", "clk_m", 129, TEGRA_PERIPH_ON_APB, tegra_clk_sata_cold, 0),
> +	GATE("sata_cold", "clk_m", 129, TEGRA_PERIPH_ON_APB, tegra_clk_sata_cold, 0),

That's a duplicate.

