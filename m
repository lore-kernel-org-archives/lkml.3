Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3KYMn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:43:28 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19782 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3KYMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:43:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 25 Nov 2013 04:41:04 -0800
Date: Mon, 25 Nov 2013 14:42:40 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: use pll_ref as the pll_e parent
Message-ID: <20131125124240.GG26617@tbergstrom-lnx.Nvidia.com>
References: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com>
 <20131122134035.GD26617@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131122134035.GD26617@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:40:35PM +0100, Peter De Schrijver wrote:
> On Wed, Oct 30, 2013 at 01:41:29AM +0100, Peter De Schrijver wrote:
> > Use pll_ref instead of pll_re_vco as the pll_e parent on Tegra114 and
> > Tegra124. Also add a pll_ref table entry for pll_e for Tegra114.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> I will squash this into the next tegra-clk-next as the previous pull request
> has never made it.
> 

Looking again at this, I think the Tegra114 and generic PLL part of the patch
better stays as a separate patch. The Tegra124 bit will be squashed into the
Tegra124 support patch.

Cheers,

Peter.
