Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaETJr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:47:59 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60427 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbaETJrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:47:55 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Olof Johansson <olof@lixom.net>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v6 0/4] Add STiH407 SoC and reference board support
Date: Tue, 20 May 2014 11:46:28 +0200
Message-Id: <1400579192-17620-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-19_03:2014-05-19,2014-05-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds basic support to the STMicroelectronics STiH407 SoC and its
B2120 reference board. The STiH407 is a dual-core ARM Cortex-A9 CPU aimed at
STB market.

Changes since v5:
-----------------
   - Sort STi boards in DTS'es Makefile
   - Re-order compatibles in STi boards from specific to generic
   - Only contains DT patches, other patches being merged

Changes since v4:
-----------------
    - remove patches already present in v3.15 (pinctrl)
    - rebase on top of v3.15-rc2

Changes since v3:
-----------------
    - Removed SOC_STIH407 as unused for now
    - Cosmetic changes in DT
    - Added new lines in pinctrl-st around if:s
    - Use ARRAY_SIZE instead of raw values

Changes since v2:
-----------------
    - Reordered the pinctrl patches
    - Moved stih407_flashdata to stih407 pinctrl patch

Changes since v1:
-----------------
    - Changed patch 2 commit title
    - Rebased pinctrl patches to linux-pinctrl/devel
    - Rebased ARM patches to arm_soc/for-next

Maxime Coquelin (4):
  ARM: dts: Sort STi boards in Makefile
  ARM: dts: Fix STi boards compatibles
  ARM: dts: Add STiH407 SoC support
  ARM: dts: STiH407: Add B2120 board support

 arch/arm/boot/dts/Makefile             |   5 +-
 arch/arm/boot/dts/stih407-b2120.dts    |  78 +++++
 arch/arm/boot/dts/stih407-clock.dtsi   |  40 +++
 arch/arm/boot/dts/stih407-pinctrl.dtsi | 615 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih407.dtsi         | 263 ++++++++++++++
 arch/arm/boot/dts/stih415-b2000.dts    |   2 +-
 arch/arm/boot/dts/stih415-b2020.dts    |   2 +-
 arch/arm/boot/dts/stih416-b2000.dts    |   3 +-
 arch/arm/boot/dts/stih416-b2020.dts    |   3 +-
 9 files changed, 1003 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih407-b2120.dts
 create mode 100644 arch/arm/boot/dts/stih407-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih407-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih407.dtsi

-- 
1.9.1

