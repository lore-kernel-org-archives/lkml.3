Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaBJRdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:33:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59712 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752218AbaBJRdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:33:04 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 0/6] Marvell Armada 375 and 38x clocks drivers
Date: Mon, 10 Feb 2014 18:32:43 +0100
Message-Id: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Here are patches that add the clocks drivers for two new Marvell ARM
SOCs that belong to the mach-mvebu family: the Armada 375 and the
Armada 380/385. They are based on Cortex-A9 CPU cores, and share a
number of peripherals with their predecessors in the mach-mvebu
family.

The drivers added are similar to the one already used for the other
SoCs of this family, as usual only the data are different the logic
remains the same ans allow us to use the common part.

The core support (arch/arm/mach-mvebu) for these SOCs have just been
posted, and we're aiming at having this merged for 3.15 if possible.

Thanks,

Gregory

Gregory CLEMENT (4):
  clk: mvebu: add clock support for Armada 375
  dt: Update binding information for mvebu core clocks with Armada 375
  dt: Update binding information for mvebu gating clocks with Armada 375
  clk: mvebu: add clock support for Armada 380/385

Thomas Petazzoni (2):
  dt: Update binding information for mvebu core clocks with Armada
    380/385
  dt: Update binding information for mvebu gating clocks with Armada
    380/385

 .../devicetree/bindings/clock/mvebu-core-clock.txt |  14 ++
 .../bindings/clock/mvebu-gated-clock.txt           |  65 +++++++-
 drivers/clk/mvebu/Kconfig                          |   8 +
 drivers/clk/mvebu/Makefile                         |   2 +
 drivers/clk/mvebu/armada-375.c                     | 184 +++++++++++++++++++++
 drivers/clk/mvebu/armada-38x.c                     | 167 +++++++++++++++++++
 6 files changed, 436 insertions(+), 4 deletions(-)
 create mode 100644 drivers/clk/mvebu/armada-375.c
 create mode 100644 drivers/clk/mvebu/armada-38x.c

-- 
1.8.1.2

