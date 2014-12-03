Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaLCMCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:02:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39879 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaLCMCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:02:12 -0500
From: Ravikumar Kattekola <rk@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Ravikumar Kattekola <rk@ti.com>
Subject: [PATCH 0/2] ARM: dts: dra7-evm: Regulator max voltage fixes
Date: Wed, 3 Dec 2014 17:33:55 +0530
Message-ID: <1417608237-12258-1-git-send-email-rk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set does a minor fix and an update:

   - Fix a typo in the max voltage property of smps6 (vdd_gpu) regulator node added by
     the patch : c56a831ca47e ("ARM: dts: DRA7: Add TPS659038 PMIC nodes")

   - Update max voltage property of smps7 (vdd_core) regulator node to align with the 
     latest Data Manual

Regards,
RK

Ravikumar Kattekola (2):
  ARM: dts: dra7-evm: Fix typo in SMPS6 (VDD_GPU) max voltage
  ARM: dts: dra7-evm: Update SMPS7 (VDD_CORE) max voltage to match DM

 arch/arm/boot/dts/dra7-evm.dts  |    4 ++--
 arch/arm/boot/dts/dra72-evm.dts |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.9.5

