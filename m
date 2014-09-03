Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbaICPjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:39:25 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42140 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700AbaICPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:39:23 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v2 0/8] phy: miphy28lp: Introduce support for MiPHY28lp
Date: Wed,  3 Sep 2014 17:37:09 +0200
Message-Id: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-03_07:2014-09-03,2014-09-03,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
from Kishon
 - create a common file for phy
 - cosmetic correction in phy-miphy28lp.txt file
 - change initialization of the registers
from Srinivas
 - rename and simplify a procedure
 - Add Tx impedance and SSC support for SATA and PCI

Hi Kishon,

The goal of this series is to add the support of MiPHY28lp Generic PHY.
I tried to be as close as possible to the MiPHY365x Lee Jones proposal.

Best Regards
Gabriel.

Gabriel Fernandez (8):
  phy: miphy28lp: Add Device Tree bindings for the MiPHY28lp
  phy: miphy28lp: Add MiPHY28lp header file for DT x Driver defines
  phy: miphy28lp: Provide support for the MiPHY28lp Generic PHY
  ARM: DT: STi: STiH407: Add DT node for MiPHY28lp
  ARM: multi_v7_defconfig: Enable MiPHY28lp - ST's Generic (SATA, PCIe &
    USB3) PHY
  phy: miphy28lp: Add SSC support for SATA
  phy: miphy28lp: Add SSC support for PCIE
  phy: miphy28lp: Tune tx impedance across Soc cuts

 .../devicetree/bindings/phy/phy-miphy28lp.txt      |  128 +++
 arch/arm/boot/dts/stih407-b2120.dts                |   11 +
 arch/arm/boot/dts/stih407.dtsi                     |   65 ++
 arch/arm/configs/multi_v7_defconfig                |    1 +
 drivers/phy/Kconfig                                |    8 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-miphy28lp.c                        | 1076 ++++++++++++++++++++
 include/dt-bindings/phy/phy-miphy.h                |   12 +
 8 files changed, 1302 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
 create mode 100644 drivers/phy/phy-miphy28lp.c
 create mode 100644 include/dt-bindings/phy/phy-miphy.h

-- 
1.9.1

