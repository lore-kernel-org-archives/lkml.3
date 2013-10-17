Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3JQMwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:52:13 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15058 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3JQMwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:52:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Oct 2013 05:47:43 -0700
Date: Thu, 17 Oct 2013 15:52:08 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/15] Introduce common infra for tegra clocks
Message-ID: <20131017125207.GT5643@tbergstrom-lnx.Nvidia.com>
References: <1382013674-12901-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1382013674-12901-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 02:41:13PM +0200, Peter De Schrijver wrote:
> This patchset introduces common infrastructure for clocks which exist in
> several Tegra SoCs. We also also move Tegra20, Tegra30 and Tegra114 to
> this new infrastructure.
> 
> Changes since v1:
> + move common clks allocation to patch 2                                                                                                                       
> + adapt also Tegra20 and Tegra30 to the changes in patch 2                                                                                                     
> 
> Changes since v2:
> + move Tegra20 and Tegra30 to the common infrastructure
> + bug fixes and comments
> + merge clk-tegra-osc.c and clk-tegra-fixed.c in 1 file
> 
> Changes since v3:
> + aggregate all changes for Tegra20 and Tegra30 into 1 file per SoC
> + add CLK_SET_RATE_PARENT for NODIV clocks to fix some warnings on Tegra30
> + rename tegra_clk_periph_banks()
> 
> Peter De Schrijver (15):
>   ARM: tegra30: add missing CLK IDs
>   clk: tegra: simplify periph clock data
>   clk: tegra: common periph_clk_enb_refcnt and clks
>   clk: tegra: Add TEGRA_PERIPH_NO_DIV flag
>   clk: tegra: move some PLLC and PLLXC init to clk-pll.c
>   clk: tegra: move fields to tegra_clk_pll_params
>   clk: tegra: add header for common tegra clock IDs
>   clk: tegra: add common infra for DT clocks
>   clk: tegra: add clkdev registration infra
>   clk: tegra: move audio clk to common file
>   clk: tegra: move periph clocks to common file
>   clk: tegra: move PMC, fixed clocks to common files
>   clk: tegra: introduce common gen4 super clock
>   clk: tegra: move tegra30 to common infra
>   clk: tegra: move tegra20 to common infra
> 

on top of git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches-1
