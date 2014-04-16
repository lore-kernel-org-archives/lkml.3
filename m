Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaDPJJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:09:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58326 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160AbaDPJJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:09:46 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH 0/6] Arizona Regulator Updates v6
Date: Wed, 16 Apr 2014 10:01:36 +0100
Message-Id: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches are small fixes/improvements to the
Arizona regulators. The main thing added is proper device
tree bindings for getting the regulator init_data.

Changes Since v5:
  - Use IS_ENABLED rather than ifdef for OF specific code
  - Tidy up arizona_of_get_named_gpio base on comments by Lee Jones

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

 Documentation/devicetree/bindings/mfd/arizona.txt |   10 ++++
 drivers/mfd/arizona-core.c                        |   41 +++++++++------
 drivers/regulator/arizona-ldo1.c                  |   57 +++++++++++++++++++++
 drivers/regulator/arizona-micsupp.c               |   37 +++++++++++++
 include/linux/mfd/arizona/core.h                  |    3 +
 5 files changed, 131 insertions(+), 17 deletions(-)

-- 
1.7.2.5

