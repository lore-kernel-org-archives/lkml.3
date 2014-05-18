Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaERUvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 16:51:14 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:44973 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbaERUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 16:51:12 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 0/2] ARM: imx: bug fix and convertion to platform_device_register_full()
Date: Sun, 18 May 2014 22:50:58 +0200
Message-Id: <1400446261-27085-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series fixes a potential NULL pointer dereference bug and
also converts the imx camera allocation and initialization functions
to use platform_device_register_full().

The change the first patch makes is removed by the second patch, so the
purpose of the first one is purely for easy backporting and git history.

Emil Goode (2):
  ARM: imx: fix error handling in ipu device registration
  ARM: imx: convert camera init to use platform_device_register_full()

 arch/arm/mach-imx/devices/platform-ipu-core.c |   43 +++++++++----------------
 arch/arm/mach-imx/mach-mx31_3ds.c             |    5 ++-
 arch/arm/mach-imx/mach-mx31moboard.c          |    6 ++--
 arch/arm/mach-imx/mach-mx35_3ds.c             |    5 ++-
 arch/arm/mach-imx/mach-pcm037.c               |    5 ++-
 5 files changed, 23 insertions(+), 41 deletions(-)

-- 
1.7.10.4

