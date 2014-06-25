Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbaFYSBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:01:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46158 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874AbaFYSBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:01:11 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <jg1.han@samsung.com>, <bhelgaas@google.com>, <mohit.kumar@st.com>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>
Subject: [PATCH 0/8] arm: dts: dra7: Add PCIe data and PCIe PHY data
Date: Wed, 25 Jun 2014 23:30:10 +0530
Message-ID: <1403719218-9484-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] is split into separate series in order for individual subsystem
Maintainers to pick up the patches. This series handles the PCIe
dt data for DRA7.

This series has better commit logs than the previous one modified as
suggested by Tero.

[1] -> https://lkml.org/lkml/2014/5/29/258

Keerthy (2):
  ARM: dts: dra7xx-clocks: Add divider table to optfclk_pciephy_div
    clock
  ARM: dts: dra7xx-clocks: Change the parent of apll_pcie_in_clk_mux to
    dpll_pcie_ref_m2ldo_ck

Kishon Vijay Abraham I (6):
  ARM: dts: dra7xx-clocks: Add missing 32KHz clocks used for PHY
  ARM: dts: dra7xx-clocks: rename pcie clocks to accommodate second PHY
    instance
  ARM: dts: dra7xx-clocks: Add missing clocks for second PCIe PHY
    instance
  ARM: dts: dra7: Add dt data for PCIe PHY control module
  ARM: dts: dra7: Add dt data for PCIe PHY
  ARM: dts: dra7: Add dt data for PCIe controller

 arch/arm/boot/dts/dra7.dtsi          |  127 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7xx-clocks.dtsi |   39 ++++++++++-
 2 files changed, 163 insertions(+), 3 deletions(-)

-- 
1.7.9.5

