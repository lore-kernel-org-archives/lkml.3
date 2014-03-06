Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaCFJSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:18:22 -0500
Received: from smtp1.macau.ctm.net ([202.175.3.59]:47634 "EHLO
	smtp1.macau.ctm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaCFJST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:18:19 -0500
From: Markus Mayer <markus.mayer@linaro.org>
To: Matt Porter <matt.porter@linaro.org>, Christian Daudt <bcm@fixthebug.org>
Cc: Device Tree List <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH v2 0/3] ARM: bcm21664: Add initial support.
Date: Thu,  6 Mar 2014 17:18:11 +0800
Message-Id: <1394097494-29899-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.0
X-TM-AS-MML: No
X-TM-AS-Product-Ver: IMSS-7.1.0.1392-7.5.0.1017-20548.005
X-TM-AS-Result: No--5.858-7.0-31-10
X-imss-scan-details: No--5.858-7.0-31-10;No--5.858-7.0-31-10
X-TMASE-MatchedRID: wfcPc0gAD6QYkHOTosTds51U1lojafr/lIvcAfYJnEoBOMBsCslSyBtA
	A+CBZv6PtYR/uNxnStHednYgFc6jdqo77AcuQhw7dARARTk4h599LQinZ4QefPcjNeVeWlqY+gt
	Hj7OwNO0UBC9Bhrukg6g5fSIcEnl7SKLf/ND6RMNBWjC2Pl8LbP7Hbz/JO6Gd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds initial support for the Broadcom BCM21664 mobile SoC.

The series depends on the series "ARM: bcm281xx: Consolidate code":
    https://lkml.org/lkml/2014/2/25/548

Changes since v1:

- Fixed typo ("21644" -> "21664" in 2 locations) in board_bcm21664.c

Markus Mayer (3):
  ARM: DT: bcm21664: Device tree bindings
  ARM: bcm21664: Add board support.
  ARM: dts: bcm21664: Add device tree files.

 .../devicetree/bindings/arm/bcm/bcm21664.txt       |  15 ++
 .../devicetree/bindings/arm/bcm/kona-resetmgr.txt  |  14 +
 arch/arm/boot/dts/Makefile                         |   3 +-
 arch/arm/boot/dts/bcm21664-garnet.dts              |  56 ++++
 arch/arm/boot/dts/bcm21664.dtsi                    | 292 +++++++++++++++++++++
 arch/arm/mach-bcm/Makefile                         |   6 +-
 arch/arm/mach-bcm/board_bcm21664.c                 |  78 ++++++
 7 files changed, 461 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/bcm21664.txt
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/kona-resetmgr.txt
 create mode 100644 arch/arm/boot/dts/bcm21664-garnet.dts
 create mode 100644 arch/arm/boot/dts/bcm21664.dtsi
 create mode 100644 arch/arm/mach-bcm/board_bcm21664.c

-- 
1.9.0

