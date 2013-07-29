Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3G2V3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:29:23 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54087 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3G2V3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:29:20 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2 0/2] OCTEON GPIO support.
Date: Mon, 29 Jul 2013 14:29:08 -0700
Message-Id: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The Cavium, OCTEON is a MIPS based SoC.  Here we add support for its
on-chip GPIO lines.

Changes from v1: Cleaned up variable names, messages and added some
comments as suggested by Linus Walleij.

The second patch depends on the first, but is in code maintained by
Ralf.  It may be best to mrege both of these together, perhaps from
the GPIO tree, with Ralf's Acked-by.

David Daney (2):
  MIPS: OCTEON: Select ARCH_REQUIRE_GPIOLIB
  gpio MIPS/OCTEON: Add a driver for OCTEON's on-chip GPIO pins.

 arch/mips/Kconfig                               |   1 +
 arch/mips/include/asm/mach-cavium-octeon/gpio.h |  21 ++++
 drivers/gpio/Kconfig                            |   8 ++
 drivers/gpio/Makefile                           |   1 +
 drivers/gpio/gpio-octeon.c                      | 157 ++++++++++++++++++++++++
 5 files changed, 188 insertions(+)
 create mode 100644 arch/mips/include/asm/mach-cavium-octeon/gpio.h
 create mode 100644 drivers/gpio/gpio-octeon.c

-- 
1.7.11.7

