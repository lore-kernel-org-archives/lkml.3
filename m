Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3IROtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:49:04 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5925 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3IROtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:49:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 07:49:01 -0700
Date: Wed, 18 Sep 2013 17:48:58 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "Thierry Reding" <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 00/12] Introduce common infra for tegra clocks
Message-ID: <20130918144858.GV30013@tbergstrom-lnx.Nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 04:40:52PM +0200, Peter De Schrijver wrote:
> This patchset introduces common infrastructure for clocks which exist in
> several Tegra SoCs. We also move Tegra114 to this new infrastructure.
> Tegra20 and Tegra30 will be moved later in separate patchsets.
> 
> Peter De Schrijver (12):
>   clk: tegra: simplify periph clock data
>   clk: tegra: periph_clk_enb_refcnt as common infra
>   clk: tegra: Add TEGRA_PERIPH_NO_DIV flag
>   clk: tegra: move some PLLC and PLLXC init to clk-pll.c
>   clk: tegra: add header for common tegra clock IDs
>   clk: tegra: add common infra for DT clocks
>   clk: tegra: move audio clk to common file
>   clk: tegra: move periph clocks to common file
>   clk: tegra: move PMC clocks to common file
>   clk: tegra: move fixed clocks to common file
>   clk: tegra: introduce common tegra_osc_clk_init
>   clk: tegra: introduce common gen4 super clock

Forgot to mention that this patchset relies on 

[PATCH] clk: tegra: replace enum tegra114_clk by binding header 

and obsoletes:

[PATCH v2 0/4] Introduce table driven initializations
