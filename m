Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaDAIga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:36:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51367 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbaDAIgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:36:16 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Arizona Regulator Updates v5
Date: Tue,  1 Apr 2014 09:27:19 +0100
Message-Id: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches are small fixes/improvements to the
Arizona regulators. The main thing added is proper device
tree bindings for getting the regulator init_data.

Changes Since v4:
  - Added a subnode section in the binding documentation and
    moved the sub-node documentation into that.

Thanks,
Charles

Charles Keepax (6):
  mfd: arizona: Factor out read of device tree GPIOs
  regulator: arizona-ldo1: Move setup processing from arizona-core
  regulator: arizona-ldo1: Add processing of init_data from device tree
  mfd: arizona: Update DT binding to support LDO1 init_data
  regulator: arizona-micsupp: Add processing of init_data from device
    tree
  mfd: arizona: Update DT binding to support MICVDD init_data

 Documentation/devicetree/bindings/mfd/arizona.txt |   10 +++
 drivers/mfd/arizona-core.c                        |   43 +++++++-----
 drivers/regulator/arizona-ldo1.c                  |   73 +++++++++++++++++++++
 drivers/regulator/arizona-micsupp.c               |   53 +++++++++++++++
 include/linux/mfd/arizona/core.h                  |    3 +
 5 files changed, 165 insertions(+), 17 deletions(-)

-- 
1.7.2.5

