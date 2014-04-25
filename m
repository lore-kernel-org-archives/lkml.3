Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaDYLbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:31:40 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40071 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaDYLbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:31:35 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, stern@rowland.harvard.edu, kishon@ti.com,
        k.debski@samsung.com, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v7 0/2] dts: Add usb2phy to Exynos 5250
Date: Fri, 25 Apr 2014 17:01:23 +0530
Message-Id: <1398425485-20574-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next version of patch for Kamil's patch:
[PATCH v6 4/8] dts: Add usb2phy to Exynos 5250
https://lkml.org/lkml/2014/1/29/302

Based on 'for-next' branch of Kgene's linux-samsung tree.
Tested with driver side patches:
[PATCH 0/2] usb: ehci/ohci-exynos: Move to generic phy framework
https://www.mail-archive.com/linux-usb@vger.kernel.org/msg41246.html

Changes from v6:
 - Splitted the patch into two:
    adding syscon nodes to Exynos5250 and Exynos5420 in first;
    and phy entry change in the second.
 - Changed the name of phandle for usb2phy from 'usb2_phy_new'
   to 'usb2_phy_gen' indicating generic phy.
 - Using clock macros in dt entries.

Kamil Debski (1):
  ARM: dts: Add usb2phy to Exynos 5250

Vivek Gautam (1):
  ARM: dts: Add sysreg sytem controller node to exynos5250 and
    exynos5420

 arch/arm/boot/dts/exynos5250.dtsi |   31 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5420.dtsi |    5 +++++
 2 files changed, 36 insertions(+)

-- 
1.7.10.4

