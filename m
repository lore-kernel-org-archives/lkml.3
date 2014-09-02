Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaIBPnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:43:05 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39197 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbaIBPnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:43:02 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        iivanov@mm-sol.com, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v2 0/3] ARM: dts: qcom: Add initial IFC6540 board support
Date: Tue,  2 Sep 2014 18:40:40 +0300
Message-Id: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic support for the IFC6540 single-board computer boards, that are
based on the APQ8084 SoC. The first patch adds the initial device tree.
The second enables the serial console. The third adds the SDHC nodes and
enables the eMMC.

Should go through the qcom/arm-soc tree.

Changes since v1:
 - This time add linux-arm-msm list to the CC.
 - Include a third patch for enabling the eMMC.

Georgi Djakov (3):
  ARM: dts: qcom: Add initial IFC6540 board device tree
  ARM: dts: qcom: Enable serial port on IFC6540 boards
  ARM: dts: qcom: Add SDHC nodes for APQ8084 platform

 arch/arm/boot/dts/Makefile                 |    1 +
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   23 +++++++++++++++++++++++
 arch/arm/boot/dts/qcom-apq8084.dtsi        |   23 +++++++++++++++++++++++
 3 files changed, 47 insertions(+)
 create mode 100644 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts

-- 
1.7.9.5

