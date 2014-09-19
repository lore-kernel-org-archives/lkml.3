Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaISMaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:30:25 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15273 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaISMaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:30:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 19 Sep 2014 05:31:02 -0700
Date: Fri, 19 Sep 2014 15:30:20 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: pull request for Tegra clock updates for 3.18
Message-ID: <20140919123020.GA12341@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

A few fixes to enable PLL_M scaling for Tegra124 and improved error handling
for clock initialization.

Thanks,

Peter.

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-3.18

Mikko Perttunen (2):
      ARM: tegra: Add PLL_M_UD and PLL_C_UD to tegra124-car binding header
      clk: tegra124: Add PLL_M_UD and PLL_C_UD clocks

Tomeu Vizoso (1):
      clk: tegra: Make clock initialization more robust

 drivers/clk/tegra/clk-tegra124.c         |    8 ++++++++
 drivers/clk/tegra/clk.c                  |    9 +++++++--
 include/dt-bindings/clock/tegra124-car.h |    6 +++++-
 3 files changed, 20 insertions(+), 3 deletions(-)
