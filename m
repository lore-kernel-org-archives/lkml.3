Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbbAPQtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:49:15 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:61797 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbbAPQtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:49:13 -0500
From: Stefan Wahren <stefan.wahren@i2se.com>
To: swarren@wwwdotorg.org, lee@kernel.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH 0/4] ARM: bcm2835: DT improvements
Date: Fri, 16 Jan 2015 16:48:13 +0000
Message-Id: <1421426897-27225-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V03:K0:HWDZ/HzdLMnTO5jZAxRO9U+iksn3YMzIeOJ84AX362YX5xuBNuG
 QMr/gFVoBe9dVMz0TScGDBZMs717W/FMV1Bj1tY40XmuaCkghHQp4HE1D7H8BDUEoEFnKIi
 fh80qh1gW5t+kyEbexp/VcqVLObmbe8iTlTRVs7tG3ZY5lEAs3KxkBQRUkGkgIOK0HU0Vs/
 OatSXFycQ9fA6iIJc7YMw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains DT improvements for the Raspberry Pi.

Patch 1,2: Add missing vendor prefix and root compatible properties
Patch 3,4: Use constants for pin function instead of error-prone numbers

Stefan Wahren (4):
  dt-bindings: Add vendor prefix for Raspberry Pi
  dt-bindings: Add root properties for Raspberry Pi B and B+
  ARM: bcm2835: Add header file for pinctrl constants
  ARM: bcm2835: Use pinctrl header

 Documentation/devicetree/bindings/arm/bcm2835.txt  |   10 ++++++--
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts           |    4 +--
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |    4 +--
 arch/arm/boot/dts/bcm2835-rpi.dtsi                 |    8 +++---
 arch/arm/boot/dts/bcm2835.dtsi                     |    3 ++-
 include/dt-bindings/pinctrl/bcm2835.h              |   27 ++++++++++++++++++++
 7 files changed, 46 insertions(+), 11 deletions(-)
 create mode 100644 include/dt-bindings/pinctrl/bcm2835.h

-- 
1.7.9.5

