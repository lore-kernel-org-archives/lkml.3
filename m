Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3J3As2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:48:28 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1313 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3J3As1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:48:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Oct 2013 17:47:54 -0700
Date: Wed, 30 Oct 2013 02:47:52 +0200
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
Subject: Re: pull request for Tegra clock rework and Tegra124 clock support
Message-ID: <20131030004752.GH22111@tbergstrom-lnx.Nvidia.com>
References: <20131021135638.GA10943@tbergstrom-lnx.Nvidia.com>
 <20131022101904.7554.73999@quantum>
 <20131023084631.GG22111@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131023084631.GG22111@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

This is an update to the previous pull request which fixes some late bugs.

Thanks,

Peter.

The following changes since commit 6c984fc8c6314596c302bbecf79dc59d9f98f348:

  clk: tegra124: add suspend/resume function for tegra_cpu_car_ops (2013-10-21 16:39:24 +0300)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-tegra124-0

Mikko Perttunen (1):
      clk: tegra114: Initialize clocks needed for HDMI

Peter De Schrijver (1):
      clk: tegra: use pll_ref as the pll_e parent

Thierry Reding (2):
      clk: tegra: Initialize secondary gr3d clock on Tegra30
      clk: tegra: Properly setup PWM clock on Tegra30

 drivers/clk/tegra/clk-pll.c      |    7 ++++---
 drivers/clk/tegra/clk-tegra114.c |    5 ++++-
 drivers/clk/tegra/clk-tegra30.c  |    5 ++++-
 3 files changed, 12 insertions(+), 5 deletions(-)
