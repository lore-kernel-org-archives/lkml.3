Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaBTR2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:28:09 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2828 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaBTR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:28:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 20 Feb 2014 09:25:46 -0800
Date: Thu, 20 Feb 2014 19:27:44 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <mturquette@linaro.org>
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
Subject: Tegra clockframework fixes for 3.14
Message-ID: <20140220172744.GA4378@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Could you merge these fixes still for 3.14?

Thanks,

Peter.

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git clk-tegra-more-fixes-3.14

Andrew Bresticker (3):
      clk: tegra: fix sdmmc clks on Tegra1x4
      clk: tegra: cclk_lp has a pllx/2 divider
      clk: tegra: use max divider if divider overflows

David Ung (1):
      clk: tegra: PLLD2 fixes for hdmi

Gabe Black (1):
      clk: tegra: Fix PLLP rate table

Mark Zhang (1):
      clk: tegra: fix host1x clock on Tegra124

Peter De Schrijver (3):
      clk: tegra: Add missing Tegra20 fuse clks
      clk: tegra: Fix vic03 mux index
      clk: tegra124: remove gr2d and gr3d clocks

Rhyland Klein (1):
      clk: tegra: Fix PLLD mnp table

Thierry Reding (1):
      clk: tegra: Correct clock number for UARTE

 drivers/clk/tegra/clk-divider.c          |    2 +-
 drivers/clk/tegra/clk-id.h               |    4 ++
 drivers/clk/tegra/clk-tegra-periph.c     |   10 ++++--
 drivers/clk/tegra/clk-tegra-super-gen4.c |    2 +-
 drivers/clk/tegra/clk-tegra114.c         |    8 ++--
 drivers/clk/tegra/clk-tegra124.c         |   48 +++++++++++++++++-------------
 drivers/clk/tegra/clk-tegra20.c          |    2 +
 include/dt-bindings/clock/tegra124-car.h |    4 +-
 8 files changed, 47 insertions(+), 33 deletions(-)
