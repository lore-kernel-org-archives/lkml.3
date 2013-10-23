Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3JWTPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:15:25 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:50755 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751513Ab3JWTPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:15:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:2:41:355:379:541:968:973:988:989:1260:1345:1437:1535:1606:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:31
X-HE-Tag: iron44_6887300a47019
X-Filterd-Recvd-Size: 6340
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-iio@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 0/8] treewide: Remove OOM message after input_alloc_device
Date: Wed, 23 Oct 2013 12:14:46 -0700
Message-Id: <cover.1382555436.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (8):
  Documentation: Remove OOM message after input_allocate_device
  cell: Remove OOM message after input_allocate_device
  hid: Remove OOM message after input_allocate_device
  input: Remove OOM message after input_allocate_device
  media: Remove OOM message after input_allocate_device
  platform:x86: Remove OOM message after input_allocate_device
  staging: Remove OOM message after input_allocate_device
  sound: Remove OOM message after input_allocate_device

 Documentation/input/input-programming.txt     | 1 -
 arch/powerpc/platforms/cell/cbe_powerbutton.c | 1 -
 drivers/hid/hid-input.c                       | 1 -
 drivers/hid/hid-picolcd_core.c                | 5 ++---
 drivers/input/joystick/as5011.c               | 2 --
 drivers/input/joystick/db9.c                  | 1 -
 drivers/input/joystick/gamecon.c              | 4 +---
 drivers/input/joystick/turbografx.c           | 1 -
 drivers/input/joystick/walkera0701.c          | 1 -
 drivers/input/keyboard/amikbd.c               | 4 +---
 drivers/input/keyboard/davinci_keyscan.c      | 1 -
 drivers/input/keyboard/gpio_keys.c            | 1 -
 drivers/input/keyboard/lpc32xx-keys.c         | 1 -
 drivers/input/keyboard/max7359_keypad.c       | 1 -
 drivers/input/keyboard/mcs_touchkey.c         | 1 -
 drivers/input/keyboard/mpr121_touchkey.c      | 1 -
 drivers/input/keyboard/nomadik-ske-keypad.c   | 1 -
 drivers/input/keyboard/opencores-kbd.c        | 1 -
 drivers/input/keyboard/pmic8xxx-keypad.c      | 1 -
 drivers/input/keyboard/pxa27x_keypad.c        | 1 -
 drivers/input/keyboard/pxa930_rotary.c        | 1 -
 drivers/input/keyboard/qt1070.c               | 1 -
 drivers/input/keyboard/qt2160.c               | 1 -
 drivers/input/keyboard/sh_keysc.c             | 1 -
 drivers/input/keyboard/tc3589x-keypad.c       | 1 -
 drivers/input/keyboard/tnetv107x-keypad.c     | 1 -
 drivers/input/keyboard/w90p910_keypad.c       | 1 -
 drivers/input/misc/88pm80x_onkey.c            | 1 -
 drivers/input/misc/88pm860x_onkey.c           | 1 -
 drivers/input/misc/arizona-haptics.c          | 4 +---
 drivers/input/misc/atlas_btns.c               | 4 +---
 drivers/input/misc/da9052_onkey.c             | 1 -
 drivers/input/misc/da9055_onkey.c             | 4 +---
 drivers/input/misc/ideapad_slidebar.c         | 1 -
 drivers/input/misc/ims-pcu.c                  | 7 +------
 drivers/input/misc/kxtj9.c                    | 4 +---
 drivers/input/misc/max8997_haptic.c           | 1 -
 drivers/input/misc/mc13783-pwrbutton.c        | 4 +---
 drivers/input/misc/mpu3050.c                  | 1 -
 drivers/input/misc/pcf8574_keypad.c           | 1 -
 drivers/input/misc/pm8xxx-vibrator.c          | 1 -
 drivers/input/misc/pmic8xxx-pwrkey.c          | 1 -
 drivers/input/misc/pwm-beeper.c               | 1 -
 drivers/input/misc/twl4030-pwrbutton.c        | 4 +---
 drivers/input/misc/twl6040-vibra.c            | 1 -
 drivers/input/mouse/appletouch.c              | 4 +---
 drivers/input/mouse/bcm5974.c                 | 4 +---
 drivers/input/mouse/cyapa.c                   | 4 +---
 drivers/input/mouse/inport.c                  | 1 -
 drivers/input/mouse/logibm.c                  | 1 -
 drivers/input/mouse/pc110pad.c                | 1 -
 drivers/input/mouse/pxa930_trkball.c          | 1 -
 drivers/input/tablet/aiptek.c                 | 5 +----
 drivers/input/tablet/gtco.c                   | 1 -
 drivers/input/touchscreen/88pm860x-ts.c       | 1 -
 drivers/input/touchscreen/atmel_mxt_ts.c      | 1 -
 drivers/input/touchscreen/atmel_tsadcc.c      | 1 -
 drivers/input/touchscreen/bu21013_ts.c        | 1 -
 drivers/input/touchscreen/cyttsp4_core.c      | 2 --
 drivers/input/touchscreen/da9034-ts.c         | 1 -
 drivers/input/touchscreen/edt-ft5x06.c        | 1 -
 drivers/input/touchscreen/eeti_ts.c           | 5 +----
 drivers/input/touchscreen/htcpen.c            | 1 -
 drivers/input/touchscreen/intel-mid-touch.c   | 1 -
 drivers/input/touchscreen/lpc32xx_ts.c        | 1 -
 drivers/input/touchscreen/mcs5000_ts.c        | 1 -
 drivers/input/touchscreen/migor_ts.c          | 1 -
 drivers/input/touchscreen/mk712.c             | 1 -
 drivers/input/touchscreen/pixcir_i2c_ts.c     | 1 -
 drivers/input/touchscreen/s3c2410_ts.c        | 1 -
 drivers/input/touchscreen/ti_am335x_tsc.c     | 1 -
 drivers/input/touchscreen/tnetv107x-ts.c      | 1 -
 drivers/media/rc/imon.c                       | 8 ++------
 drivers/media/usb/em28xx/em28xx-input.c       | 4 +---
 drivers/media/usb/pwc/pwc-if.c                | 1 -
 drivers/platform/x86/asus-laptop.c            | 5 ++---
 drivers/platform/x86/eeepc-laptop.c           | 4 +---
 drivers/platform/x86/ideapad-laptop.c         | 4 +---
 drivers/platform/x86/intel_mid_powerbtn.c     | 4 +---
 drivers/platform/x86/panasonic-laptop.c       | 5 +----
 drivers/platform/x86/thinkpad_acpi.c          | 1 -
 drivers/platform/x86/topstar-laptop.c         | 4 +---
 drivers/platform/x86/toshiba_acpi.c           | 4 +---
 drivers/staging/cptm1217/clearpad_tm1217.c    | 2 --
 drivers/staging/iio/adc/mxs-lradc.c           | 4 +---
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c | 2 --
 sound/pci/hda/hda_beep.c                      | 4 +---
 87 files changed, 29 insertions(+), 152 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

