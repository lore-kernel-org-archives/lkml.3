Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaJAKVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:21:04 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57165 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJAKVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:21:00 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Joerg Roedel <joro@8bytes.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Simon Xue <xxm@rock-chips.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH 0/3] Rockchip IOMMU driver and devicetree bindings
Date: Wed,  1 Oct 2014 18:20:40 +0800
Message-Id: <1412158843-8115-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver and devicetree bindings for the IOMMU found in Rockchip RK3288
SoCs.

Daniel Kurtz (3):
  iommu/rockchip: rk3288 iommu driver
  dt-bindings: iommu: Add documentation for rockchip iommu
  ARM: dts: rk3288: add VOP iommu nodes

 .../devicetree/bindings/iommu/rockchip,iommu.txt   |  26 +
 arch/arm/boot/dts/rk3288.dtsi                      |  18 +
 drivers/iommu/Kconfig                              |  11 +
 drivers/iommu/Makefile                             |   1 +
 drivers/iommu/rockchip-iommu.c                     | 924 +++++++++++++++++++++
 5 files changed, 980 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
 create mode 100644 drivers/iommu/rockchip-iommu.c

-- 
2.1.0.rc2.206.gedb03e5

