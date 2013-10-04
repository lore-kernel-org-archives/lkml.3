Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3JDJQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:16:03 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11526 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3JDJP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:15:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Oct 2013 02:12:00 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH 0/5] Tegra124 clock support
Date: Fri, 4 Oct 2013 12:12:39 +0300
Message-ID: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces support for the Tegra124 CAR clocks.
Based on '[PATCH v2 00/12] Introduce common infra for tegra clocks'

Peter De Schrijver (5):
  clk: tegra: Add support for PLLSS
  clk: tegra: Add periph regs bank X
  clk: tegra124: Add common clk IDs to clk-id.h
  clk: tegra124: Add new peripheral clocks
  clk: tegra124: Add support for Tegra124 clocks

 drivers/clk/tegra/Makefile               |    1 +
 drivers/clk/tegra/clk-id.h               |   27 +
 drivers/clk/tegra/clk-pll.c              |  168 +++++
 drivers/clk/tegra/clk-tegra-periph.c     |   61 ++
 drivers/clk/tegra/clk-tegra124.c         | 1206 ++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.c                  |   10 +
 drivers/clk/tegra/clk.h                  |    7 +
 include/dt-bindings/clock/tegra124-car.h |  342 +++++++++
 8 files changed, 1822 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra124.c
 create mode 100644 include/dt-bindings/clock/tegra124-car.h

-- 
1.7.7.rc0.72.g4b5ea.dirty

