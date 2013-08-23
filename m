Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3HWMXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:23:55 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43487 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3HWMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:23:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org
Subject: [PATCH 0/40] ARM: ux500: Convert to Device Tree only platform
Date: Fri, 23 Aug 2013 13:23:00 +0100
Message-Id: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started by taking out simple, unimportant pieces, then finalised by
removing the critical booting components required for booting with
ATAGs. After this patch-set the ux500 will only boot with Device Tree
enabled. DT boot appears to be unaffected by the work, tested on
Snowball.

 arch/arm/mach-ux500/Makefile                |   4 +-
 arch/arm/mach-ux500/board-mop500-audio.c    |  50 ----------
 arch/arm/mach-ux500/board-mop500-sdi.c      |  51 ----------
 arch/arm/mach-ux500/board-mop500-stuib.c    | 120 -----------------------
 arch/arm/mach-ux500/board-mop500-u8500uib.c |  92 ------------------
 arch/arm/mach-ux500/board-mop500-uib.c      | 133 -------------------------
 arch/arm/mach-ux500/board-mop500.c          | 640 ------------------------------------------------------------------------------------------------------------------------
 arch/arm/mach-ux500/board-mop500.h          |  16 ---
 arch/arm/mach-ux500/cpu-db8500.c            |  78 ---------------
 arch/arm/mach-ux500/cpu.c                   |   5 -
 arch/arm/mach-ux500/devices-common.c        |  60 ------------
 arch/arm/mach-ux500/devices-common.h        | 134 -------------------------
 arch/arm/mach-ux500/devices-db8500.c        |  93 ------------------
 arch/arm/mach-ux500/devices-db8500.h        | 109 ---------------------
 arch/arm/mach-ux500/devices.h               |   8 --
 arch/arm/mach-ux500/setup.h                 |   1 -
 arch/arm/mach-ux500/usb.c                   | 135 --------------------------
 17 files changed, 1 insertion(+), 1728 deletions(-)


