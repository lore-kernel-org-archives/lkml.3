Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaIDOk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:40:29 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:45249 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaIDOk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:40:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org
Subject: [PATCH 0/4] watchdog: Introduce new driver to support ST's Watchdog
Date: Thu,  4 Sep 2014 15:39:47 +0100
Message-Id: <1409841592-18890-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

Basic driver to support ST's LPC Watchdog device.

Kind regards,
Lee

Lee Jones (4):
  ARM: STi: DT: STiH407: Add Device Tree node for LPC Watchdog
  ARM: multi_v7_defconfig: Enable support for ST's LPC Watchdog
  watchdog: st_wdt: Provide binding documentation for ST's LPC Watchdog
    driver
  watchdog: st_wdt: Add new driver for ST's LPC Watchdog

 .../devicetree/bindings/watchdog/st-lpc-wdt.txt    |  27 ++
 arch/arm/boot/dts/stih407.dtsi                     |  10 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 drivers/watchdog/Kconfig                           |  16 ++
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/st_wdt.c                          | 314 +++++++++++++++++++++
 6 files changed, 369 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
 create mode 100644 drivers/watchdog/st_wdt.c

-- 
1.9.1

