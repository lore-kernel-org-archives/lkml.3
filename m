Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbaCRRbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:31:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45289 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbaCRRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:31:09 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        ckeepax@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Arizona regulator updates v2
Date: Tue, 18 Mar 2014 17:22:28 +0000
Message-Id: <1395163353-1608-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches are small fixes/improvements to the
Arizona regulators. The main thing added is proper device
tree bindings for getting the regulator init_data.

Changes Since v1:
  - Added of_node_put for nodes we take references to
  - I have removed the last two MFD patches from the series
  and will submit seperately as they don't really depend on
  the rest of the series.

Thanks,
Charles

Charles Keepax (5):
  arizona: Correct small errors in the DT binding documentation
  mfd: arizona: Fix and factor out read of device tree GPIOs
  regulator: arizona-ldo1: Move setup processing from arizona-core
  regulator: arizona-ldo1: Add processing of init_data from device tree
  regulator: arizona-micsupp: Add processing of init_data from device
    tree

 Documentation/devicetree/bindings/mfd/arizona.txt |   32 +++++++---
 drivers/mfd/arizona-core.c                        |   40 +++++++-----
 drivers/regulator/arizona-ldo1.c                  |   68 +++++++++++++++++++++
 drivers/regulator/arizona-micsupp.c               |   50 +++++++++++++++
 include/linux/mfd/arizona/core.h                  |    3 +
 5 files changed, 166 insertions(+), 27 deletions(-)

-- 
1.7.2.5

