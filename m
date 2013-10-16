Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab3JPQyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:54:06 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9139 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3JPQyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:54:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Oct 2013 09:53:59 -0700
Date: Wed, 16 Oct 2013 19:53:56 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <mturquette@linaro.org>
CC: <pgaikwad@nvidia.com>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>
Subject: pull request for tegra clocks based on clk-next
Message-ID: <20131016165356.GA1696@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit f61027426a5bc7093aa8359a411b053a35bb4b68:

  clk: of: helper for determining number of parent clocks (2013-10-07 23:13:33 -0700)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches-1

Andrew Chew (1):
      clk: tegra: Set the clk parent of host1x to pll_p

Mark Zhang (3):
      clk: tegra: Correct sbc mux width & parent
      clk: tegra: Fix vde/2d/3d clock src offset
      clk: tegra: Set the clock parent of gr2d/gr3d to pll_c2

Peter De Schrijver (3):
      ARM: tegra114: add missing clocks to binding
      clk: tegra: replace enum tegra114_clk by binding header
      clk: tegra: PLLE spread spectrum control

Thierry Reding (1):
      clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d

 drivers/clk/tegra/clk-pll.c              |   30 ++-
 drivers/clk/tegra/clk-tegra114.c         |  442 ++++++++++++++----------------
 include/dt-bindings/clock/tegra114-car.h |    8 +-
 3 files changed, 235 insertions(+), 245 deletions(-)
