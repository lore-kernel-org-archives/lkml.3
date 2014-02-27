Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaB0JXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:23:00 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6696 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaB0JW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:22:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 27 Feb 2014 01:20:15 -0800
Date: Thu, 27 Feb 2014 11:22:13 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
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
Subject: Re: Tegra clockframework fixes for 3.14
Message-ID: <20140227092213.GP19389@tbergstrom-lnx.Nvidia.com>
References: <20140220172744.GA4378@tbergstrom-lnx.Nvidia.com>
 <20140224010211.22529.99924@quantum>
 <20140224134319.GG19389@tbergstrom-lnx.Nvidia.com>
 <20140226101640.GM19389@tbergstrom-lnx.Nvidia.com>
 <20140226153942.22529.95697@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140226153942.22529.95697@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 04:39:42PM +0100, Mike Turquette wrote:
> Quoting Peter De Schrijver (2014-02-26 02:16:40)
> > Mike,
> > 
> > > On Mon, Feb 24, 2014 at 02:02:11AM +0100, Mike Turquette wrote:
> > > > Quoting Peter De Schrijver (2014-02-20 09:27:44)
> > > > > Hi Mike,
> > > > > 
> > > > > Could you merge these fixes still for 3.14?
> > > > 
> > > > No problem, but can you provide a list of the regressions fixed? I'll
> > > > add those to my merge commit message. No need for you to respin
> > > > anything. Next time if you could submit a signed tag with the
> > > > regressions listed in the message it would be a great help.
> > > > 
> > > 
> > > This fixes the following issues:
> > > 
> > > clk: tegra124: remove gr2d and gr3d clocks - accesses to undefined registers
> > > clk: tegra: Fix vic03 mux index - wrong parent when PLLC3 is selected (because clk_m is actually selected)
> > > clk: tegra: use max divider if divider overflows - make tegra fractional divider match the clk-div.c behaviour
> > > clk: tegra: cclk_lp has a pllx/2 divider - pllx runs at half the programmed rate
> > > clk: tegra: fix sdmmc clks on Tegra1x4 - wrong parent selection
> > > clk: tegra: fix host1x clock on Tegra124 - wrong parent selection
> > > clk: tegra: PLLD2 fixes for hdmi - PLL runs at wrong rate
> > > clk: tegra: Fix PLLD mnp table - PLL runs at wrong rate
> > > clk: tegra: Fix PLLP rate table - kernel panic when using coreboot
> > > clk: tegra: Correct clock number for UARTE - wrong clock when using UARTE
> > > clk: tegra: Add missing Tegra20 fuse clks - fuse driver broken
> > > 
> > 
> > Is this ok for you?
> 
> Yes, it's great. The tegra fixes are already part of the next batch
> towards -rc5.
> 

Ok. Thanks!

Cheers,

Peter.
