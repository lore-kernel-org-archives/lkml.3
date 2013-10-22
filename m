Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3JVPA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:00:59 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63659 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3JVPA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:00:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20131016155621.GC20211@ulmo.nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com>
 <20131016153550.GA22451@ulmo.nvidia.com>
 <20131016155336.GN5643@tbergstrom-lnx.Nvidia.com>
 <20131016155621.GC20211@ulmo.nvidia.com>
Message-ID: <20131022150049.11662.14841@quantum>
User-Agent: alot/0.3.4
Subject: Re: pull request for tegra clocks (resend with some CCs added this time)
Date: Tue, 22 Oct 2013 08:00:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Thierry Reding (2013-10-16 08:56:21)
> On Wed, Oct 16, 2013 at 06:53:36PM +0300, Peter De Schrijver wrote:
> > On Wed, Oct 16, 2013 at 05:35:51PM +0200, Thierry Reding wrote:
> > > * PGP Signed by an unknown key
> > > 
> > > On Tue, Oct 15, 2013 at 06:36:20PM +0300, Peter De Schrijver wrote:
> > > > The following changes since commit a0cf1abc25ac197dd97b857c0f6341066a8cb1cf:
> > > > 
> > > >   Add linux-next specific files for 20130927 (2013-09-27 18:48:50 +1000)
> > > > 
> > > > are available in the git repository at:
> > > >   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches-0
> > > > 
> > > > Andrew Chew (1):
> > > >       clk: tegra: Set the clk parent of host1x to pll_p
> > > > 
> > > > Mark Zhang (3):
> > > >       clk: tegra: Correct sbc mux width & parent
> > > >       clk: tegra: Fix vde/2d/3d clock src offset
> > > >       clk: tegra: Set the clock parent of gr2d/gr3d to pll_c2
> > > > 
> > > > Peter De Schrijver (3):
> > > >       ARM: tegra114: add missing clocks to binding
> > > >       clk: tegra: replace enum tegra114_clk by binding header
> > > >       clk: tegra: PLLE spread spectrum control
> > > > 
> > > > Thierry Reding (1):
> > > >       clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d
> > > 
> > > I think this pull request is missing the initialization of the display
> > > controller clocks (TEGRA114_CLK_DISP1 and TEGRA114_CLK_DISP2) from
> > > Mikko's Dalmore HDMI series.
> > 
> > I don't think they were part of the original request to be included?
> 
> Not sure, I certainly sent it to Mike for inclusion at some point. I
> guess I can respin it on top of this pull request. There is another
> small patch required for gr3d on Tegra30 which I can rebase on top of
> this as well.
> 
> Mike, do you want me to hold these back until you've merged Peter's
> Tegra series or would you rather take them all in one go? Until when
> will you be taking patches for 3.13?

Can you send another pull request with these patches that is based on
top of Peter's pull request? I've already pulled Peter's request in but
have not published it to clk-next yet, so the best way to avoid merge
issues is to just rebase those changes on top of his latest pull
request.

Mike

> 
> Thierry
