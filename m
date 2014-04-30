Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaD3Iz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:55:29 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45564 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaD3IzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:55:25 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        stern@rowland.harvard.edu, kishon@ti.com, k.debski@samsung.com,
        jg1.han@samsung.com, p.paneri@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 0/4] dts: Add usb2phy to Exynos 5250/5420
Date: Wed, 30 Apr 2014 14:25:06 +0530
Message-Id: <1398848110-6152-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next version for earlier patch-series:
[PATCH v7 0/2] dts: Add usb2phy to Exynos 5250

Based on 'for-next' branch of Kgene's linux-samsung tree.

Tested with driver side patches:
[PATCH v2 1/4] usb: ohci-exynos: Use struct device instead of platform_device
[PATCH v2 2/4] usb: ehci-exynos: Use struct device instead of platform_device
[PATCH v4 1/2] usb: ohci-exynos: Add facility to use phy provided by the generic phy framework
[PATCH v10 4/4] usb: ehci-exynos: Change to use phy provided by the generic phy framework


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

Kamil Debski (1):
  ARM: dts: Add usb2phy to Exynos 5250

Vivek Gautam (3):
  ARM: dts: Add sysreg sytem controller node to exynos5250 and
    exynos5420
  ARM: dts: Add usb2phy support on exynos5420
  ARM: dts: Add usb 2.0 support on exynos5420

 arch/arm/boot/dts/exynos5250.dtsi |   31 +++++++++++++++++++++++
 arch/arm/boot/dts/exynos5420.dtsi |   49 +++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

-- 
1.7.10.4

