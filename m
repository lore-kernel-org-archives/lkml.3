Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab3JPHib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:38:31 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6982 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3JPHi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:38:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Oct 2013 00:34:04 -0700
Date: Wed, 16 Oct 2013 10:38:27 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 13/19] clk: tegra: introduce common gen4 super clock
Message-ID: <20131016073827.GC5643@tbergstrom-lnx.Nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
 <1381848794-11761-14-git-send-email-pdeschrijver@nvidia.com>
 <525D9973.2070501@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <525D9973.2070501@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:37:23PM +0200, Stephen Warren wrote:
> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> > Introduce a common function which super clock initialization for Tegra114
> > and beyond.
> 
> Nit: s/which/{which,that} performs/ ?
> 
> For my education, why are cclk_g, cclk_lp, pll_x related to the super
> clock? I thought sclk/hclk/pclk were bus clocks, not something related
> to the CPU clock(s).

sclk (at least from tegra30 onwards) uses the same 'super clock' structure
than the CPU clocks. hclk and pclk are derived from that. Hence I considered
it sensible to define all of them in the same file.

Cheers,

Peter.
