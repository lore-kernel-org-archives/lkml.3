Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaG1Txv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:53:51 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42734 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaG1Txr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:53:47 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 0/3] arm: dts: omap3-gta04: Move common parts to include file and add models
Date: Mon, 28 Jul 2014 21:53:30 +0200
Message-Id: <1406577213-9642-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset move omap3-gta04.dts to omap3-gta04.dtsi which then share
common parts with a3,a4 and a5 models. Models a3 and a5 have only small additions
to gta04a4 model.

Marek Belisko (3):
  arm: dts: omap3-gta04: Rename gta04.dts to gta04.dtsi and add a4 model
  arm: dts: Add gta04a3 model
  arm: dts: Add gta04a5 model

 arch/arm/boot/dts/Makefile                         |  4 +-
 .../boot/dts/{omap3-gta04.dts => omap3-gta04.dtsi} |  0
 arch/arm/boot/dts/omap3-gta04a3.dts                | 48 ++++++++++++++++++++++
 arch/arm/boot/dts/omap3-gta04a4.dts                | 13 ++++++
 arch/arm/boot/dts/omap3-gta04a5.dts                | 17 ++++++++
 5 files changed, 81 insertions(+), 1 deletion(-)
 rename arch/arm/boot/dts/{omap3-gta04.dts => omap3-gta04.dtsi} (100%)
 create mode 100644 arch/arm/boot/dts/omap3-gta04a3.dts
 create mode 100644 arch/arm/boot/dts/omap3-gta04a4.dts
 create mode 100644 arch/arm/boot/dts/omap3-gta04a5.dts

-- 
1.9.1
-
