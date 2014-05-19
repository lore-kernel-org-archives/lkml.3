Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaESNkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:40:53 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14710 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbaESNkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:40:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 May 2014 06:35:04 -0700
Date: Mon, 19 May 2014 16:40:49 +0300
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
Subject: pull request for Tegra clock fixes for 3.16
Message-ID: <20140519134049.GA20109@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

A number of fixes which are needed by the upcoming XHCI and SATA drivers.

Thanks,

Peter.

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-v3.16

Andrew Bresticker (2):
      clk: tegra: Fix xusb_hs_src clock hierarchy
      clk: tegra: Initialize xusb clocks

Jim Lin (2):
      clk: tegra: Enable hardware control of PLLE
      clk: tegra: Fix xusb_fs_src mux

 drivers/clk/tegra/clk-id.h               |    1 +
 drivers/clk/tegra/clk-pll.c              |   33 +++++++++++++++++++++++++++++-
 drivers/clk/tegra/clk-tegra-periph.c     |   10 ++++++++-
 drivers/clk/tegra/clk-tegra114.c         |   22 ++++++++++----------
 drivers/clk/tegra/clk-tegra124.c         |   21 ++++++++++---------
 include/dt-bindings/clock/tegra114-car.h |    3 +-
 include/dt-bindings/clock/tegra124-car.h |    3 +-
 7 files changed, 68 insertions(+), 25 deletions(-)
