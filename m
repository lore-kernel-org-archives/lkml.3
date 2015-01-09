Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbbAIPOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:14:34 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:32955 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247AbbAIPOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:14:31 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org, peter.griffin@linaro.org
Subject: [PATCH 0/3] Add STiH418 SoC and reference board support
Date: Fri,  9 Jan 2015 16:11:43 +0100
Message-Id: <1420816306-11305-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-09_05:2015-01-09,2015-01-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds basic support to the STMicroelectronics STiH407 SoC and its
B2199 reference board. The STiH418 is a quad-core ARM Cortex-A9 CPU aimed at
UHD STB market.

Maxime Coquelin (3):
  ARM: STi: Add STiH418 SoC support
  ARM: dts: Add STiH418 SoC support
  ARM: dts: STiH418: Add B2199 board support

 Documentation/arm/sti/stih418-overview.txt    |  20 ++
 Documentation/devicetree/bindings/arm/sti.txt |   4 +
 arch/arm/boot/dts/Makefile                    |   3 +-
 arch/arm/boot/dts/stih418-b2199.dts           |  78 ++++++
 arch/arm/boot/dts/stih418-clock.dtsi          | 348 ++++++++++++++++++++++++++
 arch/arm/boot/dts/stih418.dtsi                |  99 ++++++++
 arch/arm/mach-sti/board-dt.c                  |   1 +
 include/dt-bindings/clock/stih418-clks.h      |  34 +++
 8 files changed, 586 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/arm/sti/stih418-overview.txt
 create mode 100644 arch/arm/boot/dts/stih418-b2199.dts
 create mode 100644 arch/arm/boot/dts/stih418-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih418.dtsi
 create mode 100644 include/dt-bindings/clock/stih418-clks.h

-- 
1.9.1

