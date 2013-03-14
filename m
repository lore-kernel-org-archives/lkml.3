Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab3CNNLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:11:45 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59770 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab3CNNLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:11:43 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 00/10] Use module_platform_driver_probe() part 2
Date: Thu, 14 Mar 2013 14:11:20 +0100
Message-Id: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch set is the second part for the conversion to use
new module_platform_driver_probe() macro.

I will send a part 3 for the remaining drivers.

Fabio Porcedda (10):
  drivers: media: use module_platform_driver_probe()
  drivers: ata: use module_platform_driver_probe()
  drivers: char: use module_platform_driver_probe()
  drivers: hwmon: use module_platform_driver_probe()
  drivers: ide: use module_platform_driver_probe()
  drivers: input: use module_platform_driver_probe()
  drivers: memory: use module_platform_driver_probe()
  drivers: mfd: use module_platform_driver_probe()
  drivers: video: use module_platform_driver_probe()
  drivers: misc: use module_platform_driver_probe()

 drivers/ata/pata_at32.c                        | 13 +------------
 drivers/ata/pata_samsung_cf.c                  | 13 +------------
 drivers/char/hw_random/mxc-rnga.c              | 13 +------------
 drivers/char/hw_random/tx4939-rng.c            | 13 +------------
 drivers/hwmon/mc13783-adc.c                    | 13 +------------
 drivers/ide/gayle.c                            | 15 +--------------
 drivers/ide/tx4938ide.c                        | 13 +------------
 drivers/ide/tx4939ide.c                        | 13 +------------
 drivers/input/keyboard/amikbd.c                | 14 +-------------
 drivers/input/keyboard/davinci_keyscan.c       | 12 +-----------
 drivers/input/keyboard/nomadik-ske-keypad.c    | 12 +-----------
 drivers/input/misc/twl4030-pwrbutton.c         | 13 +------------
 drivers/input/mouse/amimouse.c                 | 14 +-------------
 drivers/input/serio/at32psif.c                 | 13 +------------
 drivers/input/serio/q40kbd.c                   | 13 +------------
 drivers/input/touchscreen/atmel-wm97xx.c       | 12 +-----------
 drivers/input/touchscreen/mc13783_ts.c         | 12 +-----------
 drivers/media/platform/sh_vou.c                | 13 +------------
 drivers/media/platform/soc_camera/atmel-isi.c  | 12 +-----------
 drivers/media/platform/soc_camera/mx1_camera.c | 13 +------------
 drivers/memory/emif.c                          | 12 +-----------
 drivers/mfd/davinci_voicecodec.c               | 12 +-----------
 drivers/mfd/htc-pasic3.c                       | 13 +------------
 drivers/misc/atmel_pwm.c                       | 12 +-----------
 drivers/misc/ep93xx_pwm.c                      | 13 +------------
 drivers/video/backlight/atmel-pwm-bl.c         | 12 +-----------
 drivers/video/sh_mipi_dsi.c                    | 12 +-----------
 drivers/video/sh_mobile_hdmi.c                 | 12 +-----------
 28 files changed, 28 insertions(+), 329 deletions(-)

-- 
1.8.1.5

