Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaAFSL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:11:56 -0500
Received: from mail1.windriver.com ([147.11.146.13]:37282 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbaAFSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:11:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] input: delete non-required instances of include <linux/init.h>
Date: Mon, 6 Jan 2014 13:11:40 -0500
Message-ID: <1389031900-25978-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[build tested allyes/modconfig on x86 and powerpc]

 drivers/input/gameport/emu10k1-gp.c          | 1 -
 drivers/input/gameport/fm801-gp.c            | 1 -
 drivers/input/joystick/a3d.c                 | 1 -
 drivers/input/joystick/adi.c                 | 1 -
 drivers/input/joystick/cobra.c               | 1 -
 drivers/input/joystick/gf2k.c                | 1 -
 drivers/input/joystick/grip.c                | 1 -
 drivers/input/joystick/grip_mp.c             | 1 -
 drivers/input/joystick/guillemot.c           | 1 -
 drivers/input/joystick/iforce/iforce.h       | 1 -
 drivers/input/joystick/interact.c            | 1 -
 drivers/input/joystick/joydump.c             | 1 -
 drivers/input/joystick/magellan.c            | 1 -
 drivers/input/joystick/sidewinder.c          | 1 -
 drivers/input/joystick/spaceball.c           | 1 -
 drivers/input/joystick/spaceorb.c            | 1 -
 drivers/input/joystick/stinger.c             | 1 -
 drivers/input/joystick/tmdc.c                | 1 -
 drivers/input/joystick/twidjoy.c             | 1 -
 drivers/input/joystick/warrior.c             | 1 -
 drivers/input/joystick/xpad.c                | 1 -
 drivers/input/joystick/zhenhua.c             | 1 -
 drivers/input/keyboard/adp5520-keys.c        | 1 -
 drivers/input/keyboard/adp5588-keys.c        | 1 -
 drivers/input/keyboard/adp5589-keys.c        | 1 -
 drivers/input/keyboard/bf54x-keys.c          | 1 -
 drivers/input/keyboard/goldfish_events.c     | 1 -
 drivers/input/keyboard/gpio_keys_polled.c    | 1 -
 drivers/input/keyboard/hil_kbd.c             | 1 -
 drivers/input/keyboard/imx_keypad.c          | 1 -
 drivers/input/keyboard/jornada680_kbd.c      | 1 -
 drivers/input/keyboard/jornada720_kbd.c      | 1 -
 drivers/input/keyboard/lkkbd.c               | 1 -
 drivers/input/keyboard/matrix_keypad.c       | 1 -
 drivers/input/keyboard/mcs_touchkey.c        | 1 -
 drivers/input/keyboard/mpr121_touchkey.c     | 1 -
 drivers/input/keyboard/newtonkbd.c           | 1 -
 drivers/input/keyboard/omap-keypad.c         | 1 -
 drivers/input/keyboard/omap4-keypad.c        | 1 -
 drivers/input/keyboard/pxa27x_keypad.c       | 1 -
 drivers/input/keyboard/pxa930_rotary.c       | 1 -
 drivers/input/keyboard/qt1070.c              | 1 -
 drivers/input/keyboard/qt2160.c              | 1 -
 drivers/input/keyboard/samsung-keypad.c      | 1 -
 drivers/input/keyboard/sh_keysc.c            | 1 -
 drivers/input/keyboard/spear-keyboard.c      | 1 -
 drivers/input/keyboard/stmpe-keypad.c        | 1 -
 drivers/input/keyboard/stowaway.c            | 1 -
 drivers/input/keyboard/sunkbd.c              | 1 -
 drivers/input/keyboard/tc3589x-keypad.c      | 1 -
 drivers/input/keyboard/twl4030_keypad.c      | 1 -
 drivers/input/keyboard/w90p910_keypad.c      | 1 -
 drivers/input/keyboard/xtkbd.c               | 1 -
 drivers/input/misc/ad714x.c                  | 1 -
 drivers/input/misc/adxl34x.c                 | 1 -
 drivers/input/misc/atlas_btns.c              | 1 -
 drivers/input/misc/bfin_rotary.c             | 1 -
 drivers/input/misc/cobalt_btns.c             | 1 -
 drivers/input/misc/da9052_onkey.c            | 1 -
 drivers/input/misc/da9055_onkey.c            | 1 -
 drivers/input/misc/dm355evm_keys.c           | 1 -
 drivers/input/misc/gpio_tilt_polled.c        | 1 -
 drivers/input/misc/keyspan_remote.c          | 1 -
 drivers/input/misc/max8997_haptic.c          | 1 -
 drivers/input/misc/mc13783-pwrbutton.c       | 1 -
 drivers/input/misc/mpu3050.c                 | 1 -
 drivers/input/misc/pcap_keys.c               | 1 -
 drivers/input/misc/pcf50633-input.c          | 1 -
 drivers/input/misc/pcf8574_keypad.c          | 1 -
 drivers/input/misc/pcspkr.c                  | 1 -
 drivers/input/misc/pm8xxx-vibrator.c         | 1 -
 drivers/input/misc/pmic8xxx-pwrkey.c         | 1 -
 drivers/input/misc/powermate.c               | 1 -
 drivers/input/misc/retu-pwrbutton.c          | 1 -
 drivers/input/misc/rotary_encoder.c          | 1 -
 drivers/input/misc/sgi_btns.c                | 1 -
 drivers/input/misc/sirfsoc-onkey.c           | 1 -
 drivers/input/misc/wm831x-on.c               | 1 -
 drivers/input/misc/yealink.c                 | 1 -
 drivers/input/mouse/appletouch.c             | 1 -
 drivers/input/mouse/bcm5974.c                | 1 -
 drivers/input/mouse/cypress_ps2.c            | 1 -
 drivers/input/mouse/gpio_mouse.c             | 1 -
 drivers/input/mouse/navpoint.c               | 1 -
 drivers/input/mouse/pxa930_trkball.c         | 1 -
 drivers/input/mouse/sermouse.c               | 1 -
 drivers/input/mouse/synaptics_usb.c          | 1 -
 drivers/input/mouse/vsxxxaa.c                | 1 -
 drivers/input/serio/altera_ps2.c             | 1 -
 drivers/input/serio/ambakmi.c                | 1 -
 drivers/input/serio/libps2.c                 | 1 -
 drivers/input/serio/olpc_apsp.c              | 1 -
 drivers/input/serio/pcips2.c                 | 1 -
 drivers/input/serio/q40kbd.c                 | 1 -
 drivers/input/serio/rpckbd.c                 | 1 -
 drivers/input/serio/serio_raw.c              | 1 -
 drivers/input/serio/xilinx_ps2.c             | 1 -
 drivers/input/tablet/acecad.c                | 1 -
 drivers/input/tablet/aiptek.c                | 1 -
 drivers/input/tablet/gtco.c                  | 1 -
 drivers/input/tablet/hanwang.c               | 1 -
 drivers/input/tablet/kbtab.c                 | 1 -
 drivers/input/tablet/wacom.h                 | 1 -
 drivers/input/touchscreen/ad7877.c           | 1 -
 drivers/input/touchscreen/ad7879.c           | 1 -
 drivers/input/touchscreen/ads7846.c          | 1 -
 drivers/input/touchscreen/atmel_mxt_ts.c     | 1 -
 drivers/input/touchscreen/atmel_tsadcc.c     | 1 -
 drivers/input/touchscreen/da9034-ts.c        | 1 -
 drivers/input/touchscreen/dynapro.c          | 1 -
 drivers/input/touchscreen/egalax_ts.c        | 1 -
 drivers/input/touchscreen/elo.c              | 1 -
 drivers/input/touchscreen/fujitsu_ts.c       | 1 -
 drivers/input/touchscreen/gunze.c            | 1 -
 drivers/input/touchscreen/hampshire.c        | 1 -
 drivers/input/touchscreen/inexio.c           | 1 -
 drivers/input/touchscreen/intel-mid-touch.c  | 1 -
 drivers/input/touchscreen/jornada720_ts.c    | 1 -
 drivers/input/touchscreen/lpc32xx_ts.c       | 1 -
 drivers/input/touchscreen/mainstone-wm97xx.c | 1 -
 drivers/input/touchscreen/max11801_ts.c      | 1 -
 drivers/input/touchscreen/mcs5000_ts.c       | 1 -
 drivers/input/touchscreen/mms114.c           | 1 -
 drivers/input/touchscreen/mtouch.c           | 1 -
 drivers/input/touchscreen/pcap_ts.c          | 1 -
 drivers/input/touchscreen/penmount.c         | 1 -
 drivers/input/touchscreen/s3c2410_ts.c       | 1 -
 drivers/input/touchscreen/stmpe-ts.c         | 1 -
 drivers/input/touchscreen/ti_am335x_tsc.c    | 1 -
 drivers/input/touchscreen/touchit213.c       | 1 -
 drivers/input/touchscreen/touchright.c       | 1 -
 drivers/input/touchscreen/touchwin.c         | 1 -
 drivers/input/touchscreen/tsc40.c            | 1 -
 drivers/input/touchscreen/ucb1400_ts.c       | 1 -
 drivers/input/touchscreen/usbtouchscreen.c   | 1 -
 drivers/input/touchscreen/wacom_w8001.c      | 1 -
 drivers/input/touchscreen/wm831x-ts.c        | 1 -
 drivers/input/touchscreen/zylonite-wm97xx.c  | 1 -
 138 files changed, 138 deletions(-)

diff --git a/drivers/input/gameport/emu10k1-gp.c b/drivers/input/gameport/emu10k1-gp.c
index fa7a95c..2909e95 100644
--- a/drivers/input/gameport/emu10k1-gp.c
+++ b/drivers/input/gameport/emu10k1-gp.c
@@ -30,7 +30,6 @@
 
 #include <linux/module.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/gameport.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
diff --git a/drivers/input/gameport/fm801-gp.c b/drivers/input/gameport/fm801-gp.c
index ae912d3..7c03114 100644
--- a/drivers/input/gameport/fm801-gp.c
+++ b/drivers/input/gameport/fm801-gp.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/gameport.h>
 
diff --git a/drivers/input/joystick/a3d.c b/drivers/input/joystick/a3d.c
index 85bc8dc..55efdfc 100644
--- a/drivers/input/joystick/a3d.c
+++ b/drivers/input/joystick/a3d.c
@@ -29,7 +29,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/gameport.h>
 #include <linux/input.h>
 #include <linux/jiffies.h>
diff --git a/drivers/input/joystick/adi.c b/drivers/input/joystick/adi.c
index 0cbfd2d..b784257 100644
--- a/drivers/input/joystick/adi.c
+++ b/drivers/input/joystick/adi.c
@@ -33,7 +33,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/gameport.h>
-#include <linux/init.h>
 #include <linux/jiffies.h>
 
 #define DRIVER_DESC	"Logitech ADI joystick family driver"
diff --git a/drivers/input/joystick/cobra.c b/drivers/input/joystick/cobra.c
index 65367e4..ae3ee24 100644
--- a/drivers/input/joystick/cobra.c
+++ b/drivers/input/joystick/cobra.c
@@ -29,7 +29,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/gameport.h>
 #include <linux/input.h>
 #include <linux/jiffies.h>
diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index ab1cf28..0f519db 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -30,7 +30,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/gameport.h>
 #include <linux/jiffies.h>
diff --git a/drivers/input/joystick/grip.c b/drivers/input/joystick/grip.c
index 9e1beff..eac9c5b 100644
--- a/drivers/input/joystick/grip.c
+++ b/drivers/input/joystick/grip.c
@@ -28,7 +28,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/gameport.h>
 #include <linux/input.h>
diff --git a/drivers/input/joystick/grip_mp.c b/drivers/input/joystick/grip_mp.c
index c0f9c7b..573191d 100644
--- a/drivers/input/joystick/grip_mp.c
+++ b/drivers/input/joystick/grip_mp.c
@@ -11,7 +11,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/gameport.h>
 #include <linux/input.h>
diff --git a/drivers/input/joystick/guillemot.c b/drivers/input/joystick/guillemot.c
index 55196f7..a9ac2f9 100644
--- a/drivers/input/joystick/guillemot.c
+++ b/drivers/input/joystick/guillemot.c
@@ -30,7 +30,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/gameport.h>
 #include <linux/input.h>
 #include <linux/jiffies.h>
diff --git a/drivers/input/joystick/iforce/iforce.h b/drivers/input/joystick/iforce/iforce.h
index b1d7d9b..96ae4f5 100644
--- a/drivers/input/joystick/iforce/iforce.h
+++ b/drivers/input/joystick/iforce/iforce.h
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/usb.h>
 #include <linux/serio.h>
diff --git a/drivers/input/joystick/interact.c b/drivers/input/joystick/interact.c
index 88c2262..17c2c80 100644
--- a/drivers/input/joystick/interact.c
+++ b/drivers/input/joystick/interact.c
@@ -33,7 +33,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/gameport.h>
 #include <linux/input.h>
 #include <linux/jiffies.h>
diff --git a/drivers/input/joystick/joydump.c b/drivers/input/joystick/joydump.c
index 7eb878b..d1c6e48 100644
--- a/drivers/input/joystick/joydump.c
+++ b/drivers/input/joystick/joydump.c
@@ -31,7 +31,6 @@
 #include <linux/gameport.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 
 #define DRIVER_DESC	"Gameport data dumper module"
diff --git a/drivers/input/joystick/magellan.c b/drivers/input/joystick/magellan.c
index 9fb153e..c5358ba 100644
--- a/drivers/input/joystick/magellan.c
+++ b/drivers/input/joystick/magellan.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Magellan and SpaceMouse 6dof controller driver"
 
diff --git a/drivers/input/joystick/sidewinder.c b/drivers/input/joystick/sidewinder.c
index 04c69af..4a95b22 100644
--- a/drivers/input/joystick/sidewinder.c
+++ b/drivers/input/joystick/sidewinder.c
@@ -30,7 +30,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/gameport.h>
 #include <linux/jiffies.h>
diff --git a/drivers/input/joystick/spaceball.c b/drivers/input/joystick/spaceball.c
index 80a7b27..f4445a4 100644
--- a/drivers/input/joystick/spaceball.c
+++ b/drivers/input/joystick/spaceball.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/serio.h>
 
diff --git a/drivers/input/joystick/spaceorb.c b/drivers/input/joystick/spaceorb.c
index a41f291..f266782 100644
--- a/drivers/input/joystick/spaceorb.c
+++ b/drivers/input/joystick/spaceorb.c
@@ -32,7 +32,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/serio.h>
 
diff --git a/drivers/input/joystick/stinger.c b/drivers/input/joystick/stinger.c
index 0f51a60..099c6d7 100644
--- a/drivers/input/joystick/stinger.c
+++ b/drivers/input/joystick/stinger.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Gravis Stinger gamepad driver"
 
diff --git a/drivers/input/joystick/tmdc.c b/drivers/input/joystick/tmdc.c
index 5ef9bcd..7e17cde 100644
--- a/drivers/input/joystick/tmdc.c
+++ b/drivers/input/joystick/tmdc.c
@@ -33,7 +33,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/gameport.h>
 #include <linux/input.h>
 #include <linux/jiffies.h>
diff --git a/drivers/input/joystick/twidjoy.c b/drivers/input/joystick/twidjoy.c
index 2556a81..7f7e5ab 100644
--- a/drivers/input/joystick/twidjoy.c
+++ b/drivers/input/joystick/twidjoy.c
@@ -52,7 +52,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Handykey Twiddler keyboard as a joystick driver"
 
diff --git a/drivers/input/joystick/warrior.c b/drivers/input/joystick/warrior.c
index 23b3071..e13a914 100644
--- a/drivers/input/joystick/warrior.c
+++ b/drivers/input/joystick/warrior.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Logitech WingMan Warrior joystick driver"
 
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 75e3b10..618ea0a 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -74,7 +74,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/module.h>
diff --git a/drivers/input/joystick/zhenhua.c b/drivers/input/joystick/zhenhua.c
index c4de438..30af2e8 100644
--- a/drivers/input/joystick/zhenhua.c
+++ b/drivers/input/joystick/zhenhua.c
@@ -49,7 +49,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"RC transmitter with 5-byte Zhen Hua protocol joystick driver"
 
diff --git a/drivers/input/keyboard/adp5520-keys.c b/drivers/input/keyboard/adp5520-keys.c
index ef26b17..92cebde 100644
--- a/drivers/input/keyboard/adp5520-keys.c
+++ b/drivers/input/keyboard/adp5520-keys.c
@@ -8,7 +8,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/mfd/adp5520.h>
diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 3ed2351..7b7783b 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/workqueue.h>
diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
index 60dafd4..297735a 100644
--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/workqueue.h>
diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index 09b91d0..861becf 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -30,7 +30,6 @@
 
 #include <linux/module.h>
 
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/input/keyboard/goldfish_events.c b/drivers/input/keyboard/goldfish_events.c
index 9f60a2e..69e8547 100644
--- a/drivers/input/keyboard/goldfish_events.c
+++ b/drivers/input/keyboard/goldfish_events.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/input.h>
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 4e42819..e571e19 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -17,7 +17,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input-polldev.h>
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index 589e3c2..610a8af 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -36,7 +36,6 @@
 #include <linux/serio.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/pci_ids.h>
diff --git a/drivers/input/keyboard/imx_keypad.c b/drivers/input/keyboard/imx_keypad.c
index 328cfc1..8f2b2ee 100644
--- a/drivers/input/keyboard/imx_keypad.c
+++ b/drivers/input/keyboard/imx_keypad.c
@@ -13,7 +13,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index a2a034c..69b1f00 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -16,7 +16,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input-polldev.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index b0ad457..cd729d4 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -18,7 +18,6 @@
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
index fc0a63c..9fcd9f1 100644
--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -65,7 +65,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/workqueue.h>
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 90ff73a..8d2e19e 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -14,7 +14,6 @@
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/keyboard/mcs_touchkey.c b/drivers/input/keyboard/mcs_touchkey.c
index 7c236f9..68a9713 100644
--- a/drivers/input/keyboard/mcs_touchkey.c
+++ b/drivers/input/keyboard/mcs_touchkey.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c/mcs.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/keyboard/mpr121_touchkey.c b/drivers/input/keyboard/mpr121_touchkey.c
index f7f3e9a..fde6d79 100644
--- a/drivers/input/keyboard/mpr121_touchkey.c
+++ b/drivers/input/keyboard/mpr121_touchkey.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
diff --git a/drivers/input/keyboard/newtonkbd.c b/drivers/input/keyboard/newtonkbd.c
index f971898..20f0443 100644
--- a/drivers/input/keyboard/newtonkbd.c
+++ b/drivers/input/keyboard/newtonkbd.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
-#include <linux/init.h>
 #include <linux/serio.h>
 
 #define DRIVER_DESC	"Newton keyboard driver"
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index d0d5226..b14b660 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -25,7 +25,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/input.h>
diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index 30acfd4..0400b3f 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/errno.h>
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 186138c..d8241ba 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -18,7 +18,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/device.h>
diff --git a/drivers/input/keyboard/pxa930_rotary.c b/drivers/input/keyboard/pxa930_rotary.c
index 248cdcf..5c6d593 100644
--- a/drivers/input/keyboard/pxa930_rotary.c
+++ b/drivers/input/keyboard/pxa930_rotary.c
@@ -8,7 +8,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/keyboard/qt1070.c b/drivers/input/keyboard/qt1070.c
index 6c561ec..52cd6e8 100644
--- a/drivers/input/keyboard/qt1070.c
+++ b/drivers/input/keyboard/qt1070.c
@@ -25,7 +25,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
 #include <linux/slab.h>
diff --git a/drivers/input/keyboard/qt2160.c b/drivers/input/keyboard/qt2160.c
index 1c0ddad..819b228 100644
--- a/drivers/input/keyboard/qt2160.c
+++ b/drivers/input/keyboard/qt2160.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/input/keyboard/samsung-keypad.c b/drivers/input/keyboard/samsung-keypad.c
index ac43a48..c7ebe94 100644
--- a/drivers/input/keyboard/samsung-keypad.c
+++ b/drivers/input/keyboard/samsung-keypad.c
@@ -14,7 +14,6 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
diff --git a/drivers/input/keyboard/sh_keysc.c b/drivers/input/keyboard/sh_keysc.c
index fe0e498..ba4e416 100644
--- a/drivers/input/keyboard/sh_keysc.c
+++ b/drivers/input/keyboard/sh_keysc.c
@@ -12,7 +12,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index 85ff530..258af10 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -12,7 +12,6 @@
 
 #include <linux/clk.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/io.h>
diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
index 5cbec56..c6727dd 100644
--- a/drivers/input/keyboard/stmpe-keypad.c
+++ b/drivers/input/keyboard/stmpe-keypad.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/keyboard/stowaway.c b/drivers/input/keyboard/stowaway.c
index cc612c5..a6e0d56 100644
--- a/drivers/input/keyboard/stowaway.c
+++ b/drivers/input/keyboard/stowaway.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
-#include <linux/init.h>
 #include <linux/serio.h>
 
 #define DRIVER_DESC	"Stowaway keyboard driver"
diff --git a/drivers/input/keyboard/sunkbd.c b/drivers/input/keyboard/sunkbd.c
index 5f836b1..dc6bb9d 100644
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/workqueue.h>
diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index 208de7c..74494a3 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/keyboard/twl4030_keypad.c b/drivers/input/keyboard/twl4030_keypad.c
index d2d178c..3535dc2 100644
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -27,7 +27,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
index 7b03916..7c35ef3 100644
--- a/drivers/input/keyboard/w90p910_keypad.c
+++ b/drivers/input/keyboard/w90p910_keypad.c
@@ -11,7 +11,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/device.h>
diff --git a/drivers/input/keyboard/xtkbd.c b/drivers/input/keyboard/xtkbd.c
index d050d9d..7c2325b 100644
--- a/drivers/input/keyboard/xtkbd.c
+++ b/drivers/input/keyboard/xtkbd.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/input.h>
-#include <linux/init.h>
 #include <linux/serio.h>
 
 #define DRIVER_DESC	"XT keyboard driver"
diff --git a/drivers/input/misc/ad714x.c b/drivers/input/misc/ad714x.c
index 2e5d5e1..1f0ddfc 100644
--- a/drivers/input/misc/ad714x.c
+++ b/drivers/input/misc/ad714x.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
diff --git a/drivers/input/misc/adxl34x.c b/drivers/input/misc/adxl34x.c
index 1cb1da2..28a5bbe 100644
--- a/drivers/input/misc/adxl34x.c
+++ b/drivers/input/misc/adxl34x.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
index 5d44023..c0c5b63 100644
--- a/drivers/input/misc/atlas_btns.c
+++ b/drivers/input/misc/atlas_btns.c
@@ -25,7 +25,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/types.h>
 #include <asm/uaccess.h>
diff --git a/drivers/input/misc/bfin_rotary.c b/drivers/input/misc/bfin_rotary.c
index cd139cb..370e929 100644
--- a/drivers/input/misc/bfin_rotary.c
+++ b/drivers/input/misc/bfin_rotary.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/pm.h>
diff --git a/drivers/input/misc/cobalt_btns.c b/drivers/input/misc/cobalt_btns.c
index b5d71d2..3e11510 100644
--- a/drivers/input/misc/cobalt_btns.c
+++ b/drivers/input/misc/cobalt_btns.c
@@ -17,7 +17,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
  */
-#include <linux/init.h>
 #include <linux/input-polldev.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
index 020569a..1f695f2 100644
--- a/drivers/input/misc/da9052_onkey.c
+++ b/drivers/input/misc/da9052_onkey.c
@@ -11,7 +11,6 @@
  * option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index a0af8b2..4b11ede 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -11,7 +11,6 @@
  * option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/misc/dm355evm_keys.c b/drivers/input/misc/dm355evm_keys.c
index a309a5c..0eba94f 100644
--- a/drivers/input/misc/dm355evm_keys.c
+++ b/drivers/input/misc/dm355evm_keys.c
@@ -9,7 +9,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
diff --git a/drivers/input/misc/gpio_tilt_polled.c b/drivers/input/misc/gpio_tilt_polled.c
index 714c683..feeda2c 100644
--- a/drivers/input/misc/gpio_tilt_polled.c
+++ b/drivers/input/misc/gpio_tilt_polled.c
@@ -16,7 +16,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input-polldev.h>
diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
index 290fa5f..01f3b5b 100644
--- a/drivers/input/misc/keyspan_remote.c
+++ b/drivers/input/misc/keyspan_remote.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb/input.h>
diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
index e973133..1fea548 100644
--- a/drivers/input/misc/max8997_haptic.c
+++ b/drivers/input/misc/max8997_haptic.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
diff --git a/drivers/input/misc/mc13783-pwrbutton.c b/drivers/input/misc/mc13783-pwrbutton.c
index d0277a7..0df6e8d 100644
--- a/drivers/input/misc/mc13783-pwrbutton.c
+++ b/drivers/input/misc/mc13783-pwrbutton.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/input.h>
diff --git a/drivers/input/misc/mpu3050.c b/drivers/input/misc/mpu3050.c
index 6983ffb..5e50513 100644
--- a/drivers/input/misc/mpu3050.c
+++ b/drivers/input/misc/mpu3050.c
@@ -30,7 +30,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
diff --git a/drivers/input/misc/pcap_keys.c b/drivers/input/misc/pcap_keys.c
index 40ac9a5..cd23036 100644
--- a/drivers/input/misc/pcap_keys.c
+++ b/drivers/input/misc/pcap_keys.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
diff --git a/drivers/input/misc/pcf50633-input.c b/drivers/input/misc/pcf50633-input.c
index 73b13eb..db92f4f 100644
--- a/drivers/input/misc/pcf50633-input.c
+++ b/drivers/input/misc/pcf50633-input.c
@@ -16,7 +16,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
diff --git a/drivers/input/misc/pcf8574_keypad.c b/drivers/input/misc/pcf8574_keypad.c
index 0deca5a..97f711a 100644
--- a/drivers/input/misc/pcf8574_keypad.c
+++ b/drivers/input/misc/pcf8574_keypad.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 7288b26..674a2cf 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/i8253.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
 #include <linux/timex.h>
diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index ec086f6..1cb2aa5 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index b49b738..7e05027 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/input/misc/powermate.c b/drivers/input/misc/powermate.c
index 49c0c3e..63b539d 100644
--- a/drivers/input/misc/powermate.c
+++ b/drivers/input/misc/powermate.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/usb/input.h>
 
diff --git a/drivers/input/misc/retu-pwrbutton.c b/drivers/input/misc/retu-pwrbutton.c
index 7ca09ba..4bff1aa 100644
--- a/drivers/input/misc/retu-pwrbutton.c
+++ b/drivers/input/misc/retu-pwrbutton.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/irq.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/input.h>
diff --git a/drivers/input/misc/rotary_encoder.c b/drivers/input/misc/rotary_encoder.c
index f920ba7..99b9e42 100644
--- a/drivers/input/misc/rotary_encoder.c
+++ b/drivers/input/misc/rotary_encoder.c
@@ -16,7 +16,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/device.h>
diff --git a/drivers/input/misc/sgi_btns.c b/drivers/input/misc/sgi_btns.c
index 95cf299..f104749 100644
--- a/drivers/input/misc/sgi_btns.c
+++ b/drivers/input/misc/sgi_btns.c
@@ -17,7 +17,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
  */
-#include <linux/init.h>
 #include <linux/input-polldev.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
diff --git a/drivers/input/misc/sirfsoc-onkey.c b/drivers/input/misc/sirfsoc-onkey.c
index 7b8b03e..e8897c3 100644
--- a/drivers/input/misc/sirfsoc-onkey.c
+++ b/drivers/input/misc/sirfsoc-onkey.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/misc/wm831x-on.c b/drivers/input/misc/wm831x-on.c
index caa2c406..173b6dc 100644
--- a/drivers/input/misc/wm831x-on.c
+++ b/drivers/input/misc/wm831x-on.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index 285a5bd..79c964c 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -47,7 +47,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index e42f1fa..800ca7d 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -30,7 +30,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb/input.h>
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index a73f961..c329cdb 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -34,7 +34,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb/input.h>
diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index a5869a8..87095e2 100644
--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -15,7 +15,6 @@
  * the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 6b44413..0d174e0f 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -8,7 +8,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/input-polldev.h>
diff --git a/drivers/input/mouse/navpoint.c b/drivers/input/mouse/navpoint.c
index 0b8d335..1ccc88a 100644
--- a/drivers/input/mouse/navpoint.c
+++ b/drivers/input/mouse/navpoint.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
diff --git a/drivers/input/mouse/pxa930_trkball.c b/drivers/input/mouse/pxa930_trkball.c
index 0ecb9e7..d77a7a7 100644
--- a/drivers/input/mouse/pxa930_trkball.c
+++ b/drivers/input/mouse/pxa930_trkball.c
@@ -10,7 +10,6 @@
  *  published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/drivers/input/mouse/sermouse.c b/drivers/input/mouse/sermouse.c
index d5928fd..8df5266 100644
--- a/drivers/input/mouse/sermouse.c
+++ b/drivers/input/mouse/sermouse.c
@@ -32,7 +32,6 @@
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Serial mouse driver"
 
diff --git a/drivers/input/mouse/synaptics_usb.c b/drivers/input/mouse/synaptics_usb.c
index 64cf34e..e122bda 100644
--- a/drivers/input/mouse/synaptics_usb.c
+++ b/drivers/input/mouse/synaptics_usb.c
@@ -39,7 +39,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
index e900d46..3829823 100644
--- a/drivers/input/mouse/vsxxxaa.c
+++ b/drivers/input/mouse/vsxxxaa.c
@@ -82,7 +82,6 @@
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC "Driver for DEC VSXXX-AA and -GA mice and VSXXX-AB tablet"
 
diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index 4777a73..cce69d6 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index 4e2fd44..3e3776c 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -10,7 +10,6 @@
  * (at your option) any later version.
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/serio.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/serio/libps2.c b/drivers/input/serio/libps2.c
index 07a8363..7551699 100644
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -18,7 +18,6 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/i8042.h>
-#include <linux/init.h>
 #include <linux/libps2.h>
 
 #define DRIVER_DESC	"PS/2 driver library"
diff --git a/drivers/input/serio/olpc_apsp.c b/drivers/input/serio/olpc_apsp.c
index 51b1d40..5d2fe7e 100644
--- a/drivers/input/serio/olpc_apsp.c
+++ b/drivers/input/serio/olpc_apsp.c
@@ -16,7 +16,6 @@
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/serio.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/serio/pcips2.c b/drivers/input/serio/pcips2.c
index 76f8383..1715965 100644
--- a/drivers/input/serio/pcips2.c
+++ b/drivers/input/serio/pcips2.c
@@ -16,7 +16,6 @@
 #include <linux/input.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/serio.h>
 #include <linux/delay.h>
 #include <asm/io.h>
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index 7a65a1b..594256c 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -30,7 +30,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/serio.h>
 #include <linux/interrupt.h>
 #include <linux/err.h>
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 567566a..e462e77 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -29,7 +29,6 @@
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/serio.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 59df2e7..c9a02fe 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -15,7 +15,6 @@
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 #include <linux/major.h>
 #include <linux/device.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
index dfbcd87..e6cf52e 100644
--- a/drivers/input/serio/xilinx_ps2.c
+++ b/drivers/input/serio/xilinx_ps2.c
@@ -20,7 +20,6 @@
 #include <linux/interrupt.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index e062ec8..889f6b7 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb/input.h>
 
 /*
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index ee83c39..e7f966d 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -74,7 +74,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb/input.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 29e01ab..caecffe 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -53,7 +53,6 @@ Scott Hill shill@gtcocalcomp.com
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff --git a/drivers/input/tablet/hanwang.c b/drivers/input/tablet/hanwang.c
index 5cc0412..cd85205 100644
--- a/drivers/input/tablet/hanwang.c
+++ b/drivers/input/tablet/hanwang.c
@@ -26,7 +26,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb/input.h>
 
 #define DRIVER_AUTHOR   "Xing Wei <weixing@hanwang.com.cn>"
diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 3fba74b..d2ac7c2 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -1,7 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb/input.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index b79d451..9ebf0ed 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -86,7 +86,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
-#include <linux/init.h>
 #include <linux/usb/input.h>
 #include <linux/power_supply.h>
 #include <asm/unaligned.h>
diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 69834dd..46ba8e1 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -37,7 +37,6 @@
 
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index facd305..7d4cd43 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index ea19536..97f2895 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -19,7 +19,6 @@
  */
 #include <linux/types.h>
 #include <linux/hwmon.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 59aa240..4705560 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index bddabc5..e539b01 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -12,7 +12,6 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation.
  */
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/input/touchscreen/da9034-ts.c b/drivers/input/touchscreen/da9034-ts.c
index 34ad841..61e9869 100644
--- a/drivers/input/touchscreen/da9034-ts.c
+++ b/drivers/input/touchscreen/da9034-ts.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
diff --git a/drivers/input/touchscreen/dynapro.c b/drivers/input/touchscreen/dynapro.c
index 1809677..86237a9 100644
--- a/drivers/input/touchscreen/dynapro.c
+++ b/drivers/input/touchscreen/dynapro.c
@@ -24,7 +24,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Dynapro serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index 054d225..e6bcb13 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -18,7 +18,6 @@
 */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
diff --git a/drivers/input/touchscreen/elo.c b/drivers/input/touchscreen/elo.c
index 957423d..8051a4b 100644
--- a/drivers/input/touchscreen/elo.c
+++ b/drivers/input/touchscreen/elo.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 #include <linux/ctype.h>
 
 #define DRIVER_DESC	"Elo serial touchscreen driver"
diff --git a/drivers/input/touchscreen/fujitsu_ts.c b/drivers/input/touchscreen/fujitsu_ts.c
index 10794dd..d0e46a7 100644
--- a/drivers/input/touchscreen/fujitsu_ts.c
+++ b/drivers/input/touchscreen/fujitsu_ts.c
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Fujitsu serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/gunze.c b/drivers/input/touchscreen/gunze.c
index 41c7176..e2ee626 100644
--- a/drivers/input/touchscreen/gunze.c
+++ b/drivers/input/touchscreen/gunze.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Gunze AHL-51S touchscreen driver"
 
diff --git a/drivers/input/touchscreen/hampshire.c b/drivers/input/touchscreen/hampshire.c
index 0cc47ea..ecb1e0e 100644
--- a/drivers/input/touchscreen/hampshire.c
+++ b/drivers/input/touchscreen/hampshire.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Hampshire serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/inexio.c b/drivers/input/touchscreen/inexio.c
index a29c99c..adb80b6 100644
--- a/drivers/input/touchscreen/inexio.c
+++ b/drivers/input/touchscreen/inexio.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"iNexio serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/intel-mid-touch.c b/drivers/input/touchscreen/intel-mid-touch.c
index e30d837..4f6b156 100644
--- a/drivers/input/touchscreen/intel-mid-touch.c
+++ b/drivers/input/touchscreen/intel-mid-touch.c
@@ -27,7 +27,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/err.h>
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index e463a79..7324c5c 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/platform_device.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/drivers/input/touchscreen/lpc32xx_ts.c b/drivers/input/touchscreen/lpc32xx_ts.c
index 9101ee5..2058253 100644
--- a/drivers/input/touchscreen/lpc32xx_ts.c
+++ b/drivers/input/touchscreen/lpc32xx_ts.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/platform_device.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index 7d2b213..0786010 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/touchscreen/max11801_ts.c b/drivers/input/touchscreen/max11801_ts.c
index 9f84fcd..a68ec14 100644
--- a/drivers/input/touchscreen/max11801_ts.c
+++ b/drivers/input/touchscreen/max11801_ts.c
@@ -33,7 +33,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
diff --git a/drivers/input/touchscreen/mcs5000_ts.c b/drivers/input/touchscreen/mcs5000_ts.c
index f9f4e0c..baf371e 100644
--- a/drivers/input/touchscreen/mcs5000_ts.c
+++ b/drivers/input/touchscreen/mcs5000_ts.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c/mcs.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/touchscreen/mms114.c b/drivers/input/touchscreen/mms114.c
index 1443532..8a598c0 100644
--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/of.h>
 #include <linux/i2c.h>
diff --git a/drivers/input/touchscreen/mtouch.c b/drivers/input/touchscreen/mtouch.c
index eb66b7c..9b5552a 100644
--- a/drivers/input/touchscreen/mtouch.c
+++ b/drivers/input/touchscreen/mtouch.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"MicroTouch serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/pcap_ts.c b/drivers/input/touchscreen/pcap_ts.c
index f22e04d..cff2376 100644
--- a/drivers/input/touchscreen/pcap_ts.c
+++ b/drivers/input/touchscreen/pcap_ts.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index b49f0b8..417d873 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -21,7 +21,6 @@
 #include <linux/input.h>
 #include <linux/input/mt.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"PenMount serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
index b061af2..e2d109c 100644
--- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/gpio.h>
 #include <linux/input.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
index 59e81b0..42ce31a 100644
--- a/drivers/input/touchscreen/stmpe-ts.c
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 68beada..6c9cd12 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -14,7 +14,6 @@
  */
 
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/module.h>
diff --git a/drivers/input/touchscreen/touchit213.c b/drivers/input/touchscreen/touchit213.c
index 5f29e5b..c27cf8f 100644
--- a/drivers/input/touchscreen/touchit213.c
+++ b/drivers/input/touchscreen/touchit213.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Sahara TouchIT-213 serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/touchright.c b/drivers/input/touchscreen/touchright.c
index 8a2887d..4000e52 100644
--- a/drivers/input/touchscreen/touchright.c
+++ b/drivers/input/touchscreen/touchright.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Touchright serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/touchwin.c b/drivers/input/touchscreen/touchwin.c
index 588cdcb..ba90f44 100644
--- a/drivers/input/touchscreen/touchwin.c
+++ b/drivers/input/touchscreen/touchwin.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define DRIVER_DESC	"Touchwindow serial touchscreen driver"
 
diff --git a/drivers/input/touchscreen/tsc40.c b/drivers/input/touchscreen/tsc40.c
index eb96f16..2968787 100644
--- a/drivers/input/touchscreen/tsc40.c
+++ b/drivers/input/touchscreen/tsc40.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 
 #define PACKET_LENGTH  5
 struct tsc_ser {
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 1271f97..0926e96 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 5f87bed..a096633 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -51,7 +51,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
 #include <linux/hid.h>
diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 9a83be6..2792ca3 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/input/mt.h>
 #include <linux/serio.h>
-#include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
 
diff --git a/drivers/input/touchscreen/wm831x-ts.c b/drivers/input/touchscreen/wm831x-ts.c
index 6be2eb6..1b953a0 100644
--- a/drivers/input/touchscreen/wm831x-ts.c
+++ b/drivers/input/touchscreen/wm831x-ts.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/pm.h>
 #include <linux/input.h>
diff --git a/drivers/input/touchscreen/zylonite-wm97xx.c b/drivers/input/touchscreen/zylonite-wm97xx.c
index bf0869a..e2ccd68 100644
--- a/drivers/input/touchscreen/zylonite-wm97xx.c
+++ b/drivers/input/touchscreen/zylonite-wm97xx.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
-- 
1.8.4.1

