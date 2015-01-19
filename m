Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbbASXYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 18:24:01 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:54606 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbASXX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 18:23:59 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Carlo Caione <carlo@caione.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 0/3] ARM: meson: add support for MINIX NEO-X8
Date: Tue, 20 Jan 2015 00:22:56 +0100
Message-Id: <1421709779-25691-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for MINIX NEO-X8, a digital media player
based on a Amlogic S802 (Meson8) SoC. It depends on the pinctrl
support for Meson8 submitted here:

  https://lkml.org/lkml/2015/1/17/87

Beniamino Galvani (3):
  of: Add vendor prefix for MINIX
  of: Define board compatible for MINIX NEO-X8
  ARM: dts: meson: add DTS file for MINIX NEO-X8

 Documentation/devicetree/bindings/arm/amlogic.txt  |   4 +
 .../devicetree/bindings/arm/geniatech.txt          |   5 -
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/meson8-minix-neo-x8.dts          | 128 +++++++++++++++++++++
 5 files changed, 134 insertions(+), 5 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/geniatech.txt
 create mode 100644 arch/arm/boot/dts/meson8-minix-neo-x8.dts

-- 
2.1.4

