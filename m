Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3JOPg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:36:27 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12691 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3JOPg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:36:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 08:36:25 -0700
Date: Tue, 15 Oct 2013 18:36:20 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <mturquette@linaro.org>
CC: <pgaikwad@nvidia.com>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>
Subject: pull request for tegra clocks (resend with some CCs added this
 time)
Message-ID: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a0cf1abc25ac197dd97b857c0f6341066a8cb1cf:

  Add linux-next specific files for 20130927 (2013-09-27 18:48:50 +1000)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches-0

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
