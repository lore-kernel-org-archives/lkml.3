Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab3FRQFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:05:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59063 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304Ab3FRQFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:05:17 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 0/4] ARM: OMAP2+: Panda USB Host support and DVI EDID fix
Date: Tue, 18 Jun 2013 19:04:43 +0300
Message-ID: <1371571487-14389-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit & Tony,

The first two patches make changes to dts files to get USB host support
and DVI EDID to work on Panda.

The third patch should get USB host functional on uEVM.

The fourth patch is a temporary workaround to create a clock alias to
the USB PHY clock as it is not possible to define this via device tree.
This patch is required for USB host to work on Panda and uEVM.

The first 3 patches are for Benoit and the last one is for Tony.

Changes in v2:
- Fixed subject for patch 4
- Added "regulator-always-on" for Panda's USB Hub regulator

cheers,
-roger

Roger Quadros (4):
  ARM: dts: omap4-panda: Add USB Host support
  ARM: dts: omap4-panda: Fix DVI EDID reads
  ARM: dts: omap5-uevm: Provide USB Host PHY clock frequency
  ARM: OMAP2+: Provide alias to USB PHY clock

 arch/arm/boot/dts/omap4-panda-common.dtsi |   69 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap5-uevm.dts          |    7 +++
 arch/arm/mach-omap2/board-generic.c       |   23 +++++++++-
 3 files changed, 98 insertions(+), 1 deletions(-)

-- 
1.7.4.1

