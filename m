Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3FMNnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:43:55 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50133 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3FMNny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:43:54 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/4] ARM: mxs: Various Crystalfontz DT additions
Date: Thu, 13 Jun 2013 15:43:41 +0200
Message-Id: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patchset that adds support for two new Crystalfontz boards, add
enable the USB port on the CFA-10036, and fix the chip select pin number for
the 10049. 

Thanks,
Maxime

Brian Lilly (3):
  ARM: cfa10049: Switch the chip select pin of the LCD controller
  ARM: mxs: dt: Add the Crystalfontz CFA-10055 device tree
  ARM: mxs: dt: Add Crystalfontz CFA-10057 device tree

Maxime Ripard (1):
  ARM: cfa10036: Add USB0 OTG port

 arch/arm/boot/dts/Makefile           |   2 +
 arch/arm/boot/dts/imx28-cfa10036.dts |  23 +++++
 arch/arm/boot/dts/imx28-cfa10049.dts |   4 +-
 arch/arm/boot/dts/imx28-cfa10055.dts | 179 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx28-cfa10057.dts | 191 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-mxs/mach-mxs.c         |  16 ++-
 6 files changed, 403 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm/boot/dts/imx28-cfa10055.dts
 create mode 100644 arch/arm/boot/dts/imx28-cfa10057.dts

-- 
1.8.3

