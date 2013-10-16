Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752Ab3JPPxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:53:42 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5452 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759319Ab3JPPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:53:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Oct 2013 08:53:40 -0700
Date: Wed, 16 Oct 2013 18:53:36 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: pull request for tegra clocks (resend with some CCs added this
 time)
Message-ID: <20131016155336.GN5643@tbergstrom-lnx.Nvidia.com>
References: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com>
 <20131016153550.GA22451@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131016153550.GA22451@ulmo.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 05:35:51PM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Oct 15, 2013 at 06:36:20PM +0300, Peter De Schrijver wrote:
> > The following changes since commit a0cf1abc25ac197dd97b857c0f6341066a8cb1cf:
> > 
> >   Add linux-next specific files for 20130927 (2013-09-27 18:48:50 +1000)
> > 
> > are available in the git repository at:
> >   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches-0
> > 
> > Andrew Chew (1):
> >       clk: tegra: Set the clk parent of host1x to pll_p
> > 
> > Mark Zhang (3):
> >       clk: tegra: Correct sbc mux width & parent
> >       clk: tegra: Fix vde/2d/3d clock src offset
> >       clk: tegra: Set the clock parent of gr2d/gr3d to pll_c2
> > 
> > Peter De Schrijver (3):
> >       ARM: tegra114: add missing clocks to binding
> >       clk: tegra: replace enum tegra114_clk by binding header
> >       clk: tegra: PLLE spread spectrum control
> > 
> > Thierry Reding (1):
> >       clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d
> 
> I think this pull request is missing the initialization of the display
> controller clocks (TEGRA114_CLK_DISP1 and TEGRA114_CLK_DISP2) from
> Mikko's Dalmore HDMI series.

I don't think they were part of the original request to be included?

Cheers,

Peter.
