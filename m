Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055AbaGCQRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:17:46 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2048 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbaGCQRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:17:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Jul 2014 09:07:18 -0700
Date: Thu, 3 Jul 2014 19:17:40 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: pull request for Tegra clock updates for 3.17
Message-ID: <20140703161740.GA6078@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

A few bug fixes for Tegra124 clocks and some updates for the SATA driver


The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-3.17

Mikko Perttunen (2):
      clk: tegra: Enable hardware control of SATA PLL
      clk: tegra: Add SATA clocks to Tegra124 initialization table

Peter De Schrijver (3):
      clk: tegra: fix vi_sensor clocks on Tegra124
      clk: tegra124: init table updates
      clk: tegra: export clock names for debugging

 drivers/clk/tegra/clk-pll.c          |    8 ++++++++
 drivers/clk/tegra/clk-tegra-periph.c |    4 ++--
 drivers/clk/tegra/clk-tegra114.c     |   31 ++++++++++++++++++++++++++++++-
 drivers/clk/tegra/clk-tegra124.c     |   10 +++++++++-
 drivers/clk/tegra/clk.c              |    6 ++++++
 5 files changed, 55 insertions(+), 4 deletions(-)
