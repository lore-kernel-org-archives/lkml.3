Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaIZJnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:43:39 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:51535 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbaIZJng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:43:36 -0400
From: Mikko Perttunen <cyndis@kapsi.fi>
To: edubezval@gmail.com, swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        juha-matti.tilli@iki.fi, Mikko Perttunen <cyndis@kapsi.fi>
Subject: [PATCH v6 0/4] Tegra124 soctherm driver
Date: Fri, 26 Sep 2014 12:43:09 +0300
Message-Id: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds support for the thermal monitoring features of the
soctherm unit on the Tegra124 SoC. 

The branch is also available in my github repo,
  git://github.com/cyndis/linux.git soctherm-v6

Thanks,
Mikko

Mikko Perttunen (4):
  of: Add bindings for nvidia,tegra124-soctherm
  ARM: tegra: Add soctherm and thermal zones to Tegra124 device tree
  ARM: tegra: Add thermal trip points for Jetson TK1
  thermal: Add Tegra SOCTHERM thermal management driver

 .../devicetree/bindings/thermal/tegra-soctherm.txt |  53 +++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |  44 ++
 arch/arm/boot/dts/tegra124.dtsi                    |  47 ++
 drivers/thermal/Kconfig                            |  10 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/tegra_soctherm.c                   | 471 +++++++++++++++++++++
 include/dt-bindings/thermal/tegra124-soctherm.h    |  13 +
 7 files changed, 639 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/tegra-soctherm.txt
 create mode 100644 drivers/thermal/tegra_soctherm.c
 create mode 100644 include/dt-bindings/thermal/tegra124-soctherm.h

-- 
2.1.0

