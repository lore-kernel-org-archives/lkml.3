Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab3JOPQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:16:12 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12498 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3JOPQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:16:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 Oct 2013 08:11:45 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 0/7] Tegra124 clock support
Date: Tue, 15 Oct 2013 18:14:43 +0300
Message-ID: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces support for the Tegra124 CAR clocks.                                                                                                    
Based on '[PATCH v3 00/12] Introduce common infra for tegra clocks'                                                                                            

changes since v1:

+ suspend/resume for LP1 (Joseph Lo)
+ fixed some comments
+ account for changes to the common infra code

Joseph Lo (2):
  clk: tegra124: add wait_for_reset and disable_clock for
    tegra_cpu_car_ops
  clk: tegra124: add suspend/resume function for tegra_cpu_car_ops

Peter De Schrijver (5):
  clk: tegra: Add support for PLLSS
  clk: tegra: Add periph regs bank X
  clk: tegra124: Add common clk IDs to clk-id.h
  clk: tegra124: Add new peripheral clocks
  clk: tegra124: Add support for Tegra124 clocks

 drivers/clk/tegra/Makefile               |    1 +
 drivers/clk/tegra/clk-id.h               |   20 +
 drivers/clk/tegra/clk-pll.c              |  172 ++++
 drivers/clk/tegra/clk-tegra-periph.c     |   55 ++
 drivers/clk/tegra/clk-tegra124.c         | 1430 ++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.c                  |   10 +
 drivers/clk/tegra/clk.h                  |    5 +
 include/dt-bindings/clock/tegra124-car.h |  341 +++++++
 8 files changed, 2034 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra124.c
 create mode 100644 include/dt-bindings/clock/tegra124-car.h

-- 
1.7.7.rc0.72.g4b5ea.dirty

