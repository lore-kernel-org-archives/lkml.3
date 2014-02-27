Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaB0V4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:56:16 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:11553 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaB0V4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:56:14 -0500
X-IronPort-AV: E=Sophos;i="4.97,557,1389772800"; 
   d="scan'208";a="16939952"
From: Markus Mayer <markus.mayer@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <matt.porter@linaro.org>
CC: Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH 0/3] ARM: bcm21664: Add initial support.
Date: Thu, 27 Feb 2014 13:56:03 -0800
Message-ID: <1393538166-22868-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds initial support for the Broadcom BCM21664 mobile SoC.

The series depends on the series "ARM: bcm281xx: Consolidate code":
    https://lkml.org/lkml/2014/2/25/548

Markus Mayer (3):
  ARM: DT: bcm21664: Device tree bindings
  ARM: bcm21664: Add board support.
  ARM: dts: bcm21664: Add device tree files.

 .../devicetree/bindings/arm/bcm/bcm21664.txt       |   15 +
 .../devicetree/bindings/arm/bcm/kona-resetmgr.txt  |   14 +
 arch/arm/boot/dts/Makefile                         |    3 +-
 arch/arm/boot/dts/bcm21664-garnet.dts              |   56 ++++
 arch/arm/boot/dts/bcm21664.dtsi                    |  292 ++++++++++++++++++++
 arch/arm/mach-bcm/Makefile                         |    6 +-
 arch/arm/mach-bcm/board_bcm21664.c                 |   78 ++++++
 7 files changed, 461 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/bcm21664.txt
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/kona-resetmgr.txt
 create mode 100644 arch/arm/boot/dts/bcm21664-garnet.dts
 create mode 100644 arch/arm/boot/dts/bcm21664.dtsi
 create mode 100644 arch/arm/mach-bcm/board_bcm21664.c

-- 
1.7.9.5

