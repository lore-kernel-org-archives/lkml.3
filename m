Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3IWRwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:52:35 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2362 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab3IWRwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:52:32 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH 0/3] thermal: bcm281xx: Add thermal driver
Date: Mon, 23 Sep 2013 10:51:35 -0700
Message-ID: <1379958698-7554-1-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-WSS-ID: 7E5EA1DC1R093721080-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds the support of the thermal driver for Broadcom
bcm281xx family of SoCs.

Wendy Ng (3):
  thermal: bcm281xx: Add thermal driver
  ARM: bcm281xx: Turn on Thermal and HWMON drivers.
  ARM: bcm281xx: Add thermal driver to device tree.

 .../bindings/thermal/bcm-kona-thermal.txt          |   18 +++
 arch/arm/boot/dts/bcm11351-brt.dts                 |    4 +-
 arch/arm/boot/dts/bcm11351.dtsi                    |    6 +
 arch/arm/boot/dts/bcm28155-ap.dts                  |    4 +
 arch/arm/configs/bcm_defconfig                     |    3 +-
 drivers/thermal/Kconfig                            |   10 ++
 drivers/thermal/Makefile                           |    1 +
 drivers/thermal/bcm_thermal.c                      |  170 ++++++++++++++++++++
 8 files changed, 214 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
 create mode 100644 drivers/thermal/bcm_thermal.c

-- 
1.7.9.5


