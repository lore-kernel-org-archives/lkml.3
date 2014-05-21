Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaEUO6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:58:00 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53073 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbaEUO56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:57:58 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sboyd@codeaurora.org, rvaswani@codeaurora.org,
        davidb@codeaurora.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 0/4] Add Qualcomm APQ8084 SoC support
Date: Wed, 21 May 2014 17:57:01 +0300
Message-Id: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds basic support for the Qualcomm Snapdragon 805 APQ8084 SoC.

The first two patches add device-tree files for the SoC and the board, the
second adds the board compatible string to the DT machine descriptor and the
third patch adds the low-level debug UART base address and a Kconfig entry.

Tested on APQ8084-MTP board.

Georgi Djakov (4):
  ARM: dts: qcom: Add APQ8084 SoC support
  ARM: dts: qcom: Add APQ8084-MTP board support
  ARM: qcom: Add APQ8084-MTP board to mach-qcom
  ARM: debug: qcom: Add APQ8084 DEBUG_LL UART support

 arch/arm/Kconfig.debug                 |    9 ++
 arch/arm/boot/dts/Makefile             |    3 +-
 arch/arm/boot/dts/qcom-apq8084-mtp.dts |    6 ++
 arch/arm/boot/dts/qcom-apq8084.dtsi    |  180 ++++++++++++++++++++++++++++++++
 arch/arm/include/debug/msm.S           |    5 +
 arch/arm/mach-qcom/board.c             |    1 +
 6 files changed, 203 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/qcom-apq8084-mtp.dts
 create mode 100644 arch/arm/boot/dts/qcom-apq8084.dtsi

-- 
1.7.9.5

