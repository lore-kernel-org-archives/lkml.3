Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaCRK5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:57:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42321 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754889AbaCRK5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:57:54 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Arizona regulator updates
Date: Tue, 18 Mar 2014 10:49:09 +0000
Message-Id: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches are small fixes/improvments to the
Arizona regulators. The main thing added is proper device
tree bindings for getting the regulator init_data.

I would probably suggest putting the whole series through
the regulator tree since that is the focus of the work.

Thanks,
Charles

Charles Keepax (8):
  arizona: Correct small errors in the DT binding documentation
  mfd: arizona: Factor out read of device tree GPIOs
  regulator: arizona-ldo1: Move setup processing from arizona-core
  regulator: arizona-ldo1: Add processing of init_data from device tree
  regulator: arizona-micsupp: Add processing of init_data from device tree
  mfd: arizona: Add MICVDD to mapped regulators
  mfd: wm8997: Add registers for high power mode
  regulator: arizona-ldo1: Correct default regulator init_data

 Documentation/devicetree/bindings/mfd/arizona.txt |   32 ++++++---
 drivers/mfd/arizona-core.c                        |   41 +++++++-----
 drivers/mfd/wm8997-tables.c                       |    2 +
 drivers/regulator/arizona-ldo1.c                  |   74 ++++++++++++++++++---
 drivers/regulator/arizona-micsupp.c               |   47 ++++++++++++-
 include/linux/mfd/arizona/core.h                  |    3 +
 6 files changed, 159 insertions(+), 40 deletions(-)

-- 
1.7.2.5

