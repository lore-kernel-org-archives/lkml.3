Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3ERJPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 05:15:19 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:58808 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3ERJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 05:15:16 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 0/4] FB updates for 3.11
Date: Sat, 18 May 2013 21:15:10 +1200
Message-Id: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch #1 - Move register defines inside the driver and drop the header.
Patch #2 - Convert the register defines to use the vendor preferred names.
Patch #3 - Add a device clock to wm8505fb. Without it, only the uboot
initialized resolution is supported.
Patch #4 - Add support for the VGA output found on the APC8750 board.

Tony Prisk (4):
  fb: vt8500: Move register defines inside driver
  fb: vt8500: Convert to use vendor register names
  fb: vt8500: Require a device clock for wm8505fb driver
  fb: vt8500: Add VGA output support to wm8505fb driver.

 .../devicetree/bindings/video/wm,wm8505-fb.txt     |    9 +-
 drivers/video/wm8505fb.c                           |  195 ++++++++++++--
 drivers/video/wm8505fb_regs.h                      |   76 ------
 drivers/video/wmt_ge_rops.c                        |  280 +++++++++++++++-----
 4 files changed, 394 insertions(+), 166 deletions(-)
 delete mode 100644 drivers/video/wm8505fb_regs.h

-- 
1.7.9.5

