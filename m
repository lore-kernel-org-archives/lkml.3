Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbaGNUUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:20:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55793 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbaGNUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:20:45 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 0/5] Add gta04 board variants
Date: Mon, 14 Jul 2014 22:20:23 +0200
Message-Id: <1405369228-27197-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series completes the GTA04 device tree to describe all hardware
components that are on the different variants of the GTA04 boards.

Marek Belisko (5):
  arm: dts: omap3-gta04: Add missing nodes to fully describe gta04 board
  arm: dts: omap3-gta04: Rename gta04.dts to gta04.dtsi and add a4 model
  arm: dts: Add gta04a3 model
  arm: dts: Add gta04+b2 model bindings
  arm: dts: Add gta04+b3 model bindings

 arch/arm/boot/dts/Makefile           |   5 +-
 arch/arm/boot/dts/omap3-gta04+b2.dts |  99 +++++
 arch/arm/boot/dts/omap3-gta04+b3.dts | 118 ++++++
 arch/arm/boot/dts/omap3-gta04.dts    | 341 -----------------
 arch/arm/boot/dts/omap3-gta04.dtsi   | 722 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap3-gta04a3.dts  |  48 +++
 arch/arm/boot/dts/omap3-gta04a4.dts  |  13 +
 7 files changed, 1004 insertions(+), 342 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-gta04+b2.dts
 create mode 100644 arch/arm/boot/dts/omap3-gta04+b3.dts
 delete mode 100644 arch/arm/boot/dts/omap3-gta04.dts
 create mode 100644 arch/arm/boot/dts/omap3-gta04.dtsi
 create mode 100644 arch/arm/boot/dts/omap3-gta04a3.dts
 create mode 100644 arch/arm/boot/dts/omap3-gta04a4.dts

-- 
1.9.1

