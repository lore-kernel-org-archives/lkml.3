Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbaEINXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:23:18 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37765 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbaEINXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:23:16 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        robh+dt@kernel.org, stern@rowland.harvard.edu, kishon@ti.com,
        k.debski@samsung.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v2 0/4] dts: Add usb2phy to Exynos 5250/5420
Date: Fri,  9 May 2014 18:53:00 +0530
Message-Id: <1399641784-10833-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'for-next' branch of Kgene's linux-samsung tree.
These patches are as per discussions on the driver side patches
which have already been acked. [1]

Changes from v1:
 - Rebase on 'for-next' branch.
 - Removed 'phy-names' property as per discuusion in the driver patches. [1]

V1 of this series was the next version for earlier patch-series:
[PATCH v7 0/2] dts: Add usb2phy to Exynos 5250 [2]

Changes from v7 series:
 - Added patches to enable usb 2.0 support on exynos5420;
   which include dt nodes for usb2phy as well as ehci and ohci
   controllers.

Changes from v6:
 - Splitted the patch into two:
    adding syscon nodes to Exynos5250 and Exynos5420 in first;
    and phy entry change in the second.
 - Changed the name of phandle for usb2phy from 'usb2_phy_new'
   to 'usb2_phy_gen' indicating generic phy.
 - Using clock macros in dt entries.

[1] http://www.spinics.net/lists/linux-usb/msg106908.html
    http://www.spinics.net/lists/linux-usb/msg106837.html
[2] http://www.spinics.net/lists/linux-usb/msg106427.html

Kamil Debski (1):
  ARM: dts: Add usb2phy to Exynos 5250

Vivek Gautam (3):
  ARM: dts: Add sysreg sytem controller node to exynos5250 and
    exynos5420
  ARM: dts: Add usb2phy support on exynos5420
  ARM: dts: Add usb 2.0 support on exynos5420

 arch/arm/boot/dts/exynos5250.dtsi |   27 ++++++++++++++++++++++
 arch/arm/boot/dts/exynos5420.dtsi |   45 +++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

-- 
1.7.10.4

