Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3KVNkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:40:40 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8586 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3KVNki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:40:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 22 Nov 2013 05:34:33 -0800
Date: Fri, 22 Nov 2013 15:40:35 +0200
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
Message-ID: <20131122134035.GD26617@tbergstrom-lnx.Nvidia.com>
References: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1383093707-10312-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 01:41:29AM +0100, Peter De Schrijver wrote:
> Use pll_ref instead of pll_re_vco as the pll_e parent on Tegra114 and
> Tegra124. Also add a pll_ref table entry for pll_e for Tegra114.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

I will squash this into the next tegra-clk-next as the previous pull request
has never made it.

Cheers,

Peter.
