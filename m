Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbaIIQvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:51:16 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:60887 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaIIQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:51:14 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, olof@lixom.net, arnd@arndb.de,
        jason@lakedaemon.net, thomas.petazzoni@free-electrons.com,
        swarren@nvidia.com, sebastian.hesselbarth@gmail.com, stefan@agner.ch,
        maxime.ripard@free-electrons.com, matthias.bgg@gmail.com,
        anders.berg@lsi.com, linus.walleij@linaro.org, lee.jones@linaro.org,
        heiko@sntech.de, srv_yingjoe.chen@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/7] arm: mediatek: Add more basic features
Date: Tue,  9 Sep 2014 18:50:57 +0200
Message-Id: <1410281464-9587-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds some minor changes to the Mediatek mt6589 support.

Features are low-level debugging on the mt6589, the addition to the
"make dtbs" and multi_v7_defconfig, earlyprintk suppport, as well as a small
changes in the DTS files.

The patch set is based on v3.17-rc1

Changes for v3:
- drop quirk to enable ARM arch timer

Changes for v2:
- rebased on v3.17-rc1
- add patch for the compatible property of aquaris5
- add patch setting GIC compatible string to new "arm,cortex-a7-gic"
- set ARM arch timer frequency in DTS

---

Matthias Brugger (7):
  arm: dts: Build dtb for Mediatek board
  arm: multi_v7_defconfig: Enable Mediatek platform
  arm: dts: mt6589: Fix typo in GIC unit address
  arm: mediatek: Add earlyprintk support for mt6589
  arm: dts: mt6589-aquaris5: Add boot argument earlyprintk
  arm: dts: mediatek: Add compatible property for aquaris5
  arm: dts: mt6589: Change compatible string for GIC

 Documentation/devicetree/bindings/arm/mediatek.txt |  6 ++++++
 arch/arm/Kconfig.debug                             | 10 ++++++++++
 arch/arm/boot/dts/Makefile                         |  1 +
 arch/arm/boot/dts/mt6589-aquaris5.dts              |  5 +++++
 arch/arm/boot/dts/mt6589.dtsi                      |  4 ++--
 arch/arm/configs/multi_v7_defconfig                |  1 +
 6 files changed, 25 insertions(+), 2 deletions(-)

-- 
1.9.1

