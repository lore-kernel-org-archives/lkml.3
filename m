Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaJHJfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:35:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55965 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaJHJdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:33:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux@roeck-us.net
Subject: [PATCH v3 0/4] watchdog: Introduce new driver to support ST's Watchdog
Date: Wed,  8 Oct 2014 10:33:26 +0100
Message-Id: <1412760810-23199-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

Basic driver to support ST's LPC Watchdog device.
 
Kind regards,
Lee
 
v2 => v3:
 - Don't stop Watchdog during .remove()
 - Remove superflous {EN,DIS}ABLE defines
 - Add missing clk_disable_unprepare()

v1 => v2:
 - Fixed reset enable masks
 - Fixed DT documentation

Lee Jones (4):
  ARM: STi: DT: STiH407: Add Device Tree node for LPC Watchdog
  ARM: multi_v7_defconfig: Enable support for ST's LPC Watchdog
  watchdog: st_wdt: Provide binding documentation for ST's LPC Watchdog
    driver
  watchdog: st_wdt: Add new driver for ST's LPC Watchdog

 .../devicetree/bindings/watchdog/st-lpc-wdt.txt    |  30 ++
 arch/arm/boot/dts/stih407.dtsi                     |  10 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 drivers/watchdog/Kconfig                           |  16 ++
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/st_wdt.c                          | 317 +++++++++++++++++++++
 6 files changed, 375 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
 create mode 100644 drivers/watchdog/st_wdt.c

-- 
1.9.1

