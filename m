Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaCaMIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:08:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45788 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbaCaMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:08:37 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Arizona Regulator Updates v4
Date: Mon, 31 Mar 2014 12:59:41 +0100
Message-Id: <1396267187-30580-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches are small fixes/improvements to the
Arizona regulators. The main thing added is proper device
tree bindings for getting the regulator init_data.

Changes Since v3:
  - We now only process the DT information if there is no
    pdata, similar to arizona-core.
  - DT binding documention factored out into a seperate
    patch as requested.

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

 Documentation/devicetree/bindings/mfd/arizona.txt |    9 +++
 drivers/mfd/arizona-core.c                        |   43 +++++++-----
 drivers/regulator/arizona-ldo1.c                  |   73 +++++++++++++++++++++
 drivers/regulator/arizona-micsupp.c               |   53 +++++++++++++++
 include/linux/mfd/arizona/core.h                  |    3 +
 5 files changed, 164 insertions(+), 17 deletions(-)

-- 
1.7.2.5

