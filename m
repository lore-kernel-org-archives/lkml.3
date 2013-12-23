Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3LXJ3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 04:29:46 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5366 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3LXJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 04:29:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Dec 2013 01:30:40 -0800
Date: Mon, 23 Dec 2013 18:27:05 +0200
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
Subject: pull request for some small fixes
Message-ID: <20131223162705.GE3378@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 62ce7cd62f534023224912dc9b909963f26a38da:

  clk: tegra: fix __clk_lookup() return value checks (2013-11-28 15:09:22 +0200)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git clk-tegra-next-1

Peter De Schrijver (1):
      clk: tegra: Add missing Tegra20 fuse clks

Thierry Reding (1):
      clk: tegra: Correct clock number for UARTE

 drivers/clk/tegra/clk-tegra-periph.c |    2 +-
 drivers/clk/tegra/clk-tegra20.c      |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)
