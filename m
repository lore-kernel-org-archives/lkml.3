Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaELIfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:35:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4314 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaELIfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:35:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 May 2014 01:30:26 -0700
Date: Mon, 12 May 2014 11:35:14 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "mturquette@linaro.org" <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: pull request for Tegra PLLE fixes
Message-ID: <20140512083514.GW30476@tbergstrom-lnx.Nvidia.com>
References: <20140423145939.GA11307@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140423145939.GA11307@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:59:39PM +0200, Peter De Schrijver wrote:
> Hi Mike,
> 
> This fixes a number of stability problems with PCIe on Tegra30.
> 
> The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:
> 
>   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)
> 
> are available in the git repository at:
>   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git  clk-tegra-fixes-3.15
> 
> Thierry Reding (3):
>       clk: tegra: Fix PLLE programming
>       clk: tegra: Introduce divider mask and shift helpers
>       clk: tegra: Fix enabling of PLLE
> 
>  drivers/clk/tegra/clk-pll.c |   64 +++++++++++++++++++++++++++++--------------
>  1 files changed, 43 insertions(+), 21 deletions(-)

Mike,

Did you take this in?

Thanks,

Peter.
