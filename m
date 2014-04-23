Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbaDWPcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:32:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55239 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaDWP3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:29:38 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, stern@rowland.harvard.edu, balbi@ti.com,
        jg1.han@samsung.com, av.tikhomirov@samsung.com
Subject: [PATCH 0/3] dts: exynos5: Add required VDD supplies for USB
Date: Wed, 23 Apr 2014 20:59:26 +0530
Message-Id: <1398266969-26000-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on for-next branch of Kgene's linux-samsung tree, with
following patch series:
[PATCH 0/9] Enable USB 3.0 support on Exynos5 systems
https://lkml.org/lkml/2014/4/23/389

These are device tree patches corresponding to the usb driver patch-series:
[PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
[PATCH 2/3] usb: ehci-exynos: Make provision for vdd regulators
[PATCH 3/3] usb: dwc3-exynos: Make provision for vdd regulators

Vivek Gautam (3):
  dts: exynos5250: Add required VDD regulator supplies for usb
  dts: exynos5250-snow: Add required VDD regulator supplies for usb
  dts: exynos5420-smdk5420: Add required VDD regulator supplies for usb

 arch/arm/boot/dts/exynos5250-smdk5250.dts |   12 ++++++++++++
 arch/arm/boot/dts/exynos5250-snow.dts     |   12 ++++++++++++
 arch/arm/boot/dts/exynos5420-smdk5420.dts |   20 ++++++++++++++++++++
 3 files changed, 44 insertions(+)

-- 
1.7.10.4

