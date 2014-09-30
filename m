Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaI3USL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:18:11 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:50961 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaI3USH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:18:07 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        dmitry.torokhov@gmail.com
Cc: hns@goldelico.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 0/3] input: tsc2007: Extend for pre-calibration, flipping and rotation
Date: Tue, 30 Sep 2014 22:17:31 +0200
Message-Id: <1412108254-19234-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following series add support to tsc2007 touchscreen driver for pre-calibration,
flipping and rotation. Added bindings are documented and used in gta04 device tree.

Marek Belisko (3):
  input: tsc2007: Add pre-calibration, flipping and rotation
  Documentation: dt: input: tsc2007: Document new parameters
  arm: dts: omap3-gta04: Extend touchscreen configs

 .../bindings/input/touchscreen/tsc2007.txt         | 17 ++++-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |  6 ++
 drivers/input/touchscreen/tsc2007.c                | 89 +++++++++++++++++++++-
 include/linux/i2c/tsc2007.h                        |  6 ++
 4 files changed, 111 insertions(+), 7 deletions(-)

-- 
1.9.3

