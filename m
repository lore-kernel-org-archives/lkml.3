Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaGNHsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:48:45 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:33907 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaGNHsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:48:38 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, mkl@pengutronix.de
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 0/4] ARM: vf610: add FlexCAN support
Date: Mon, 14 Jul 2014 09:48:27 +0200
Message-Id: <cover.1405322992.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for Vybrid (aka vf610) to the FlexCAN
controller and extends the device tree accordingly.

Changes in v2:
- Split out patch (seperate dt, clocks and driver changes)
- Use spaces for hardware feature flags table
- Remove drive-by change of esdhc register length
- Added related fix which enables clock in berr_counter

Stefan Agner (4):
  ARM: dts: vf610: add FlexCAN node
  ARM: imx: clk-vf610: fix FlexCAN clock gating
  can: flexcan: switch on clocks before accessing ecr register
  can: flexcan: add vf610 support for FlexCAN

 arch/arm/boot/dts/vf610.dtsi  | 23 +++++++++++
 arch/arm/mach-imx/clk-vf610.c |  6 ++-
 drivers/net/can/flexcan.c     | 89 ++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 106 insertions(+), 12 deletions(-)

-- 
2.0.1

