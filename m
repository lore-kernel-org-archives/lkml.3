Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3C0Iqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:46:54 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:53377 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3C0Iqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:46:43 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, florianschandinat@gmx.de,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 0/6] fb: vt8500: patches for 3.10
Date: Wed, 27 Mar 2013 21:46:55 +1300
Message-Id: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Not sure if you are willing to take these patches or not, but thought I would
send them just in case. These patches were sent in the 3.9 merge window, but
I didn't recieve any replies, and they didn't go in.

All the patches are specific to arch-vt8500 framebuffer drivers.

Regards
Tony Prisk

Julia Lawall (1):
  drivers/video/wm8505fb.c: use devm_ functions

Tony Prisk (5):
  video: vt8500: Make wmt_ge_rops optional
  video: vt8500: Remove unused platform_data/video-vt8500lcdfb.h
  video: vt8500: Correct descriptions in video/Kconfig
  video: vt8500: Adjust contrast in wm8505 framebuffer driver.
  video: fb: vt8500: Convert framebuffer drivers to standardized
    binding

 .../devicetree/bindings/video/via,vt8500-fb.txt    |   48 ++----
 .../devicetree/bindings/video/wm,wm8505-fb.txt     |   32 ++--
 arch/arm/boot/dts/vt8500-bv07.dts                  |   24 +--
 arch/arm/boot/dts/vt8500.dtsi                      |    8 -
 arch/arm/boot/dts/wm8505-ref.dts                   |   21 ++-
 arch/arm/boot/dts/wm8505.dtsi                      |    7 -
 arch/arm/boot/dts/wm8650-mid.dts                   |   21 ++-
 arch/arm/boot/dts/wm8650.dtsi                      |    7 -
 arch/arm/boot/dts/wm8850-w70v2.dts                 |   21 ++-
 arch/arm/boot/dts/wm8850.dtsi                      |    7 -
 drivers/video/Kconfig                              |   37 +++--
 drivers/video/vt8500lcdfb.c                        |   70 ++++-----
 drivers/video/wm8505fb.c                           |  160 ++++++++------------
 include/linux/platform_data/video-vt8500lcdfb.h    |   31 ----
 14 files changed, 194 insertions(+), 300 deletions(-)
 delete mode 100644 include/linux/platform_data/video-vt8500lcdfb.h

-- 
1.7.9.5

