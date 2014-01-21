Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaAUViR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:38:17 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50730 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaAUVZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        <linux-media@vger.kernel.org>
Subject: [PATCH 47/73] drivers/media: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:50 -0500
Message-ID: <1390339396-3479-48-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/common/btcx-risc.c                        | 1 -
 drivers/media/common/cx2341x.c                          | 1 -
 drivers/media/common/siano/smsdvb-debugfs.c             | 1 -
 drivers/media/common/tveeprom.c                         | 1 -
 drivers/media/dvb-frontends/au8522_dig.c                | 1 -
 drivers/media/dvb-frontends/au8522_priv.h               | 1 -
 drivers/media/dvb-frontends/bcm3510.c                   | 1 -
 drivers/media/dvb-frontends/cx22700.c                   | 1 -
 drivers/media/dvb-frontends/cx22702.c                   | 1 -
 drivers/media/dvb-frontends/cx24110.c                   | 1 -
 drivers/media/dvb-frontends/cx24113.c                   | 1 -
 drivers/media/dvb-frontends/cx24116.c                   | 1 -
 drivers/media/dvb-frontends/cx24117.c                   | 1 -
 drivers/media/dvb-frontends/cx24123.c                   | 1 -
 drivers/media/dvb-frontends/dib3000mb.c                 | 1 -
 drivers/media/dvb-frontends/drxd_hard.c                 | 1 -
 drivers/media/dvb-frontends/drxk_hard.c                 | 1 -
 drivers/media/dvb-frontends/ds3000.c                    | 1 -
 drivers/media/dvb-frontends/dvb_dummy_fe.c              | 1 -
 drivers/media/dvb-frontends/isl6405.c                   | 1 -
 drivers/media/dvb-frontends/isl6421.c                   | 1 -
 drivers/media/dvb-frontends/isl6423.c                   | 1 -
 drivers/media/dvb-frontends/it913x-fe.c                 | 1 -
 drivers/media/dvb-frontends/l64781.c                    | 1 -
 drivers/media/dvb-frontends/lgdt330x.c                  | 1 -
 drivers/media/dvb-frontends/lgs8gl5.c                   | 1 -
 drivers/media/dvb-frontends/lnbp21.c                    | 1 -
 drivers/media/dvb-frontends/lnbp22.c                    | 1 -
 drivers/media/dvb-frontends/m88rs2000.c                 | 1 -
 drivers/media/dvb-frontends/mb86a16.c                   | 1 -
 drivers/media/dvb-frontends/mt312.c                     | 1 -
 drivers/media/dvb-frontends/mt352.c                     | 1 -
 drivers/media/dvb-frontends/nxt200x.c                   | 1 -
 drivers/media/dvb-frontends/nxt6000.c                   | 1 -
 drivers/media/dvb-frontends/or51132.c                   | 1 -
 drivers/media/dvb-frontends/s5h1409.c                   | 1 -
 drivers/media/dvb-frontends/s5h1411.c                   | 1 -
 drivers/media/dvb-frontends/s5h1420.c                   | 1 -
 drivers/media/dvb-frontends/s5h1432.c                   | 1 -
 drivers/media/dvb-frontends/si21xx.c                    | 1 -
 drivers/media/dvb-frontends/sp8870.c                    | 1 -
 drivers/media/dvb-frontends/sp887x.c                    | 1 -
 drivers/media/dvb-frontends/stb0899_drv.c               | 1 -
 drivers/media/dvb-frontends/stb6100.c                   | 1 -
 drivers/media/dvb-frontends/stv0288.c                   | 1 -
 drivers/media/dvb-frontends/stv0297.c                   | 1 -
 drivers/media/dvb-frontends/stv0299.c                   | 1 -
 drivers/media/dvb-frontends/stv090x.c                   | 1 -
 drivers/media/dvb-frontends/stv6110x.c                  | 1 -
 drivers/media/dvb-frontends/tda10021.c                  | 1 -
 drivers/media/dvb-frontends/tda10023.c                  | 1 -
 drivers/media/dvb-frontends/tda10048.c                  | 1 -
 drivers/media/dvb-frontends/tda1004x.c                  | 1 -
 drivers/media/dvb-frontends/tda10086.c                  | 1 -
 drivers/media/dvb-frontends/tda18271c2dd.c              | 1 -
 drivers/media/dvb-frontends/tda665x.c                   | 1 -
 drivers/media/dvb-frontends/tda8083.c                   | 1 -
 drivers/media/dvb-frontends/tda8261.c                   | 1 -
 drivers/media/dvb-frontends/ves1820.c                   | 1 -
 drivers/media/dvb-frontends/ves1x93.c                   | 1 -
 drivers/media/dvb-frontends/zl10039.c                   | 1 -
 drivers/media/dvb-frontends/zl10353.c                   | 1 -
 drivers/media/i2c/adv7180.c                             | 1 -
 drivers/media/i2c/adv7183.c                             | 1 -
 drivers/media/i2c/adv7343.c                             | 1 -
 drivers/media/i2c/adv7393.c                             | 1 -
 drivers/media/i2c/ak881x.c                              | 1 -
 drivers/media/i2c/ir-kbd-i2c.c                          | 1 -
 drivers/media/i2c/ks0127.c                              | 1 -
 drivers/media/i2c/ml86v7667.c                           | 1 -
 drivers/media/i2c/mt9m032.c                             | 1 -
 drivers/media/i2c/ov7640.c                              | 1 -
 drivers/media/i2c/ov7670.c                              | 1 -
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                | 1 -
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c               | 1 -
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c                 | 1 -
 drivers/media/i2c/saa6588.c                             | 1 -
 drivers/media/i2c/saa6752hs.c                           | 1 -
 drivers/media/i2c/saa7110.c                             | 1 -
 drivers/media/i2c/saa7191.c                             | 1 -
 drivers/media/i2c/soc_camera/mt9t112.c                  | 1 -
 drivers/media/i2c/soc_camera/ov2640.c                   | 1 -
 drivers/media/i2c/soc_camera/ov772x.c                   | 1 -
 drivers/media/i2c/soc_camera/ov9640.c                   | 1 -
 drivers/media/i2c/soc_camera/ov9740.c                   | 1 -
 drivers/media/i2c/soc_camera/tw9910.c                   | 1 -
 drivers/media/i2c/sony-btf-mpx.c                        | 1 -
 drivers/media/i2c/tda7432.c                             | 1 -
 drivers/media/i2c/tvaudio.c                             | 1 -
 drivers/media/i2c/tw2804.c                              | 1 -
 drivers/media/i2c/tw9903.c                              | 1 -
 drivers/media/i2c/tw9906.c                              | 1 -
 drivers/media/i2c/uda1342.c                             | 1 -
 drivers/media/i2c/vpx3220.c                             | 1 -
 drivers/media/i2c/vs6624.c                              | 1 -
 drivers/media/pci/bt8xx/bttv-gpio.c                     | 1 -
 drivers/media/pci/bt8xx/bttv-i2c.c                      | 1 -
 drivers/media/pci/bt8xx/bttv-if.c                       | 1 -
 drivers/media/pci/bt8xx/bttv-input.c                    | 1 -
 drivers/media/pci/bt8xx/bttv-risc.c                     | 1 -
 drivers/media/pci/bt8xx/dst.c                           | 1 -
 drivers/media/pci/bt8xx/dst_ca.c                        | 1 -
 drivers/media/pci/cx18/cx18-alsa-pcm.c                  | 1 -
 drivers/media/pci/cx18/cx18-driver.h                    | 1 -
 drivers/media/pci/cx23885/cx23885-417.c                 | 1 -
 drivers/media/pci/cx23885/cx23885-alsa.c                | 1 -
 drivers/media/pci/cx23885/cx23885-cards.c               | 1 -
 drivers/media/pci/cx23885/cx23885-dvb.c                 | 1 -
 drivers/media/pci/cx23885/cx23885-i2c.c                 | 1 -
 drivers/media/pci/cx23885/cx23885-vbi.c                 | 1 -
 drivers/media/pci/cx23885/cx23885-video.c               | 1 -
 drivers/media/pci/cx25821/cx25821-alsa.c                | 1 -
 drivers/media/pci/cx25821/cx25821-audio-upstream.c      | 1 -
 drivers/media/pci/cx25821/cx25821-cards.c               | 1 -
 drivers/media/pci/cx25821/cx25821-video-upstream.c      | 1 -
 drivers/media/pci/cx25821/cx25821-video.h               | 1 -
 drivers/media/pci/cx88/cx88-alsa.c                      | 1 -
 drivers/media/pci/cx88/cx88-cards.c                     | 1 -
 drivers/media/pci/cx88/cx88-core.c                      | 1 -
 drivers/media/pci/cx88/cx88-i2c.c                       | 1 -
 drivers/media/pci/cx88/cx88-input.c                     | 1 -
 drivers/media/pci/cx88/cx88-mpeg.c                      | 1 -
 drivers/media/pci/cx88/cx88-tvaudio.c                   | 1 -
 drivers/media/pci/cx88/cx88-vbi.c                       | 1 -
 drivers/media/pci/cx88/cx88-video.c                     | 1 -
 drivers/media/pci/cx88/cx88-vp3054-i2c.c                | 1 -
 drivers/media/pci/dm1105/dm1105.c                       | 1 -
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c                  | 1 -
 drivers/media/pci/ivtv/ivtv-driver.h                    | 1 -
 drivers/media/pci/mantis/mantis_pci.c                   | 1 -
 drivers/media/pci/ngene/ngene-core.c                    | 1 -
 drivers/media/pci/ngene/ngene-dvb.c                     | 1 -
 drivers/media/pci/ngene/ngene-i2c.c                     | 1 -
 drivers/media/pci/pluto2/pluto2.c                       | 1 -
 drivers/media/pci/saa7134/saa7134-alsa.c                | 1 -
 drivers/media/pci/saa7134/saa7134-cards.c               | 1 -
 drivers/media/pci/saa7134/saa7134-i2c.c                 | 1 -
 drivers/media/pci/saa7134/saa7134-input.c               | 1 -
 drivers/media/pci/saa7134/saa7134-ts.c                  | 1 -
 drivers/media/pci/saa7134/saa7134-tvaudio.c             | 1 -
 drivers/media/pci/saa7134/saa7134-vbi.c                 | 1 -
 drivers/media/pci/saa7134/saa7134-video.c               | 1 -
 drivers/media/pci/saa7164/saa7164-cards.c               | 1 -
 drivers/media/pci/saa7164/saa7164-i2c.c                 | 1 -
 drivers/media/pci/ttpci/av7110_ir.c                     | 1 -
 drivers/media/pci/ttpci/ttpci-eeprom.c                  | 1 -
 drivers/media/pci/zoran/zoran_driver.c                  | 1 -
 drivers/media/platform/blackfin/bfin_capture.c          | 1 -
 drivers/media/platform/davinci/vpbe.c                   | 1 -
 drivers/media/platform/davinci/vpbe_display.c           | 1 -
 drivers/media/platform/davinci/vpbe_venc.c              | 1 -
 drivers/media/platform/davinci/vpfe_capture.c           | 1 -
 drivers/media/platform/fsl-viu.c                        | 1 -
 drivers/media/platform/indycam.c                        | 1 -
 drivers/media/platform/sh_vou.c                         | 1 -
 drivers/media/platform/soc_camera/atmel-isi.c           | 1 -
 drivers/media/platform/soc_camera/mx2_camera.c          | 1 -
 drivers/media/platform/soc_camera/mx3_camera.c          | 1 -
 drivers/media/platform/soc_camera/pxa_camera.c          | 1 -
 drivers/media/platform/soc_camera/soc_camera.c          | 1 -
 drivers/media/platform/soc_camera/soc_camera_platform.c | 1 -
 drivers/media/radio/dsbr100.c                           | 1 -
 drivers/media/radio/radio-isa.c                         | 1 -
 drivers/media/radio/radio-ma901.c                       | 1 -
 drivers/media/radio/radio-maxiradio.c                   | 1 -
 drivers/media/radio/radio-mr800.c                       | 1 -
 drivers/media/radio/radio-raremono.c                    | 1 -
 drivers/media/radio/radio-shark.c                       | 1 -
 drivers/media/radio/radio-shark2.c                      | 1 -
 drivers/media/radio/radio-tea5764.c                     | 1 -
 drivers/media/radio/radio-tea5777.c                     | 1 -
 drivers/media/radio/saa7706h.c                          | 1 -
 drivers/media/radio/si470x/radio-si470x.h               | 1 -
 drivers/media/radio/si4713/radio-platform-si4713.c      | 1 -
 drivers/media/radio/si4713/radio-usb-si4713.c           | 1 -
 drivers/media/radio/tef6862.c                           | 1 -
 drivers/media/rc/ati_remote.c                           | 1 -
 drivers/media/rc/gpio-ir-recv.c                         | 1 -
 drivers/media/rc/imon.c                                 | 1 -
 drivers/media/tuners/mt2063.c                           | 1 -
 drivers/media/tuners/mxl5005s.c                         | 1 -
 drivers/media/tuners/tda9887.c                          | 1 -
 drivers/media/usb/au0828/au0828-dvb.c                   | 1 -
 drivers/media/usb/au0828/au0828-i2c.c                   | 1 -
 drivers/media/usb/au0828/au0828-vbi.c                   | 1 -
 drivers/media/usb/au0828/au0828-video.c                 | 1 -
 drivers/media/usb/cx231xx/cx231xx-417.c                 | 1 -
 drivers/media/usb/cx231xx/cx231xx-avcore.c              | 1 -
 drivers/media/usb/cx231xx/cx231xx-cards.c               | 1 -
 drivers/media/usb/cx231xx/cx231xx-core.c                | 1 -
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h             | 1 -
 drivers/media/usb/cx231xx/cx231xx-vbi.c                 | 1 -
 drivers/media/usb/cx231xx/cx231xx-video.c               | 1 -
 drivers/media/usb/dvb-usb/friio-fe.c                    | 1 -
 drivers/media/usb/em28xx/em28xx-cards.c                 | 1 -
 drivers/media/usb/em28xx/em28xx-core.c                  | 1 -
 drivers/media/usb/em28xx/em28xx-vbi.c                   | 1 -
 drivers/media/usb/em28xx/em28xx-video.c                 | 1 -
 drivers/media/usb/hdpvr/hdpvr-control.c                 | 1 -
 drivers/media/usb/hdpvr/hdpvr-core.c                    | 1 -
 drivers/media/usb/hdpvr/hdpvr-video.c                   | 1 -
 drivers/media/usb/pwc/pwc-if.c                          | 1 -
 drivers/media/usb/pwc/pwc-v4l.c                         | 1 -
 drivers/media/usb/siano/smsusb.c                        | 1 -
 drivers/media/usb/stk1160/stk1160-core.c                | 1 -
 drivers/media/usb/stkwebcam/stk-webcam.c                | 1 -
 drivers/media/usb/tlg2300/pd-alsa.c                     | 1 -
 drivers/media/usb/tlg2300/pd-radio.c                    | 1 -
 drivers/media/usb/tm6000/tm6000-cards.c                 | 1 -
 drivers/media/usb/tm6000/tm6000-input.c                 | 1 -
 drivers/media/usb/tm6000/tm6000-video.c                 | 1 -
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c       | 1 -
 drivers/media/usb/ttusb-dec/ttusb_dec.c                 | 1 -
 drivers/media/usb/usbtv/usbtv.c                         | 1 -
 drivers/media/usb/usbvision/usbvision-core.c            | 1 -
 drivers/media/usb/usbvision/usbvision-i2c.c             | 1 -
 drivers/media/usb/zr364xx/zr364xx.c                     | 1 -
 drivers/media/v4l2-core/tuner-core.c                    | 1 -
 drivers/media/v4l2-core/videobuf-core.c                 | 1 -
 drivers/media/v4l2-core/videobuf-dma-contig.c           | 1 -
 drivers/media/v4l2-core/videobuf-dma-sg.c               | 1 -
 drivers/media/v4l2-core/videobuf-dvb.c                  | 1 -
 drivers/media/v4l2-core/videobuf-vmalloc.c              | 1 -
 223 files changed, 223 deletions(-)

diff --git a/drivers/media/common/btcx-risc.c b/drivers/media/common/btcx-risc.c
index ac1b268..c39610e 100644
--- a/drivers/media/common/btcx-risc.c
+++ b/drivers/media/common/btcx-risc.c
@@ -23,7 +23,6 @@
 */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
index 103ef6b..7639f5a 100644
--- a/drivers/media/common/cx2341x.c
+++ b/drivers/media/common/cx2341x.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 0bb4430..88fc961 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -21,7 +21,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/debugfs.h>
 #include <linux/spinlock.h>
 #include <linux/usb.h>
diff --git a/drivers/media/common/tveeprom.c b/drivers/media/common/tveeprom.c
index c7dace6..7e94981 100644
--- a/drivers/media/common/tveeprom.c
+++ b/drivers/media/common/tveeprom.c
@@ -32,7 +32,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index a68974f..9b9c71c 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -20,7 +20,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/delay.h>
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index aa0f16d..190d447 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -22,7 +22,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index 39a29dd..1ebb46b 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -31,7 +31,6 @@
  * Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
diff --git a/drivers/media/dvb-frontends/cx22700.c b/drivers/media/dvb-frontends/cx22700.c
index 3d399d9..1f4031a 100644
--- a/drivers/media/dvb-frontends/cx22700.c
+++ b/drivers/media/dvb-frontends/cx22700.c
@@ -21,7 +21,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/cx22702.c b/drivers/media/dvb-frontends/cx22702.c
index edc8eaf..7d6ce32 100644
--- a/drivers/media/dvb-frontends/cx22702.c
+++ b/drivers/media/dvb-frontends/cx22702.c
@@ -26,7 +26,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 95b981c..72f898e 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 
 #include "dvb_frontend.h"
 #include "cx24110.h"
diff --git a/drivers/media/dvb-frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
index 3883c3b..b7190a3 100644
--- a/drivers/media/dvb-frontends/cx24113.c
+++ b/drivers/media/dvb-frontends/cx24113.c
@@ -24,7 +24,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 
 #include "dvb_frontend.h"
 #include "cx24113.h"
diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 2916d7c..4c4c3a0 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -38,7 +38,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/firmware.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index 68f768a..c61e113 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/firmware.h>
 
 #include "tuner-i2c.h"
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index 72fb583..9c56f4a 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
index af91e0c..1b0eefc 100644
--- a/drivers/media/dvb-frontends/dib3000mb.c
+++ b/drivers/media/dvb-frontends/dib3000mb.c
@@ -23,7 +23,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 959ae36..d400579 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -24,7 +24,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index bf29a3f..5fc7ad1 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -26,7 +26,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 1e344b0..97891f3 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/firmware.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
index d5acc30..14cc1fe 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 
diff --git a/drivers/media/dvb-frontends/isl6405.c b/drivers/media/dvb-frontends/isl6405.c
index 0c642a5..21c365c 100644
--- a/drivers/media/dvb-frontends/isl6405.c
+++ b/drivers/media/dvb-frontends/isl6405.c
@@ -26,7 +26,6 @@
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/isl6421.c b/drivers/media/dvb-frontends/isl6421.c
index c77002f..0e3892f 100644
--- a/drivers/media/dvb-frontends/isl6421.c
+++ b/drivers/media/dvb-frontends/isl6421.c
@@ -26,7 +26,6 @@
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/isl6423.c b/drivers/media/dvb-frontends/isl6423.c
index dca5beb..abe1f40 100644
--- a/drivers/media/dvb-frontends/isl6423.c
+++ b/drivers/media/dvb-frontends/isl6423.c
@@ -20,7 +20,6 @@
 
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/it913x-fe.c b/drivers/media/dvb-frontends/it913x-fe.c
index 6e1c6eb..3a7724f 100644
--- a/drivers/media/dvb-frontends/it913x-fe.c
+++ b/drivers/media/dvb-frontends/it913x-fe.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 
diff --git a/drivers/media/dvb-frontends/l64781.c b/drivers/media/dvb-frontends/l64781.c
index ddf866c..ecbcc30 100644
--- a/drivers/media/dvb-frontends/l64781.c
+++ b/drivers/media/dvb-frontends/l64781.c
@@ -20,7 +20,6 @@
 
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index e046622..987275b 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -35,7 +35,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/lgs8gl5.c b/drivers/media/dvb-frontends/lgs8gl5.c
index 416cce3..72152bd 100644
--- a/drivers/media/dvb-frontends/lgs8gl5.c
+++ b/drivers/media/dvb-frontends/lgs8gl5.c
@@ -21,7 +21,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/lnbp21.c b/drivers/media/dvb-frontends/lnbp21.c
index f3ba7b5..e4ebb83 100644
--- a/drivers/media/dvb-frontends/lnbp21.c
+++ b/drivers/media/dvb-frontends/lnbp21.c
@@ -26,7 +26,6 @@
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/lnbp22.c b/drivers/media/dvb-frontends/lnbp22.c
index c463da7..e3602f8 100644
--- a/drivers/media/dvb-frontends/lnbp22.c
+++ b/drivers/media/dvb-frontends/lnbp22.c
@@ -26,7 +26,6 @@
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index b235146..4a2893a 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -22,7 +22,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
 */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/jiffies.h>
diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 9ae40ab..d02662a 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -18,7 +18,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index a74ac0d..34d1410 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -26,7 +26,6 @@
 
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/mt352.c b/drivers/media/dvb-frontends/mt352.c
index 2c3b50e..baf231c 100644
--- a/drivers/media/dvb-frontends/mt352.c
+++ b/drivers/media/dvb-frontends/mt352.c
@@ -32,7 +32,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index 4bf0575..c63b03a 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -47,7 +47,6 @@
 #define CRC_CCIT_MASK 0x1021
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/nxt6000.c b/drivers/media/dvb-frontends/nxt6000.c
index 90ae6c7..0cc0bc6 100644
--- a/drivers/media/dvb-frontends/nxt6000.c
+++ b/drivers/media/dvb-frontends/nxt6000.c
@@ -19,7 +19,6 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/or51132.c b/drivers/media/dvb-frontends/or51132.c
index 5ef9218..236fa19 100644
--- a/drivers/media/dvb-frontends/or51132.c
+++ b/drivers/media/dvb-frontends/or51132.c
@@ -36,7 +36,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
index f71b062..4ade31b 100644
--- a/drivers/media/dvb-frontends/s5h1409.c
+++ b/drivers/media/dvb-frontends/s5h1409.c
@@ -20,7 +20,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
index 6cc4b7a..3839886 100644
--- a/drivers/media/dvb-frontends/s5h1411.c
+++ b/drivers/media/dvb-frontends/s5h1411.c
@@ -20,7 +20,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index 93eeaf7..7814c13 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -24,7 +24,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/media/dvb-frontends/s5h1432.c b/drivers/media/dvb-frontends/s5h1432.c
index 6ec16a2..f3135b8 100644
--- a/drivers/media/dvb-frontends/s5h1432.c
+++ b/drivers/media/dvb-frontends/s5h1432.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
index 73b47cc..b21cb00 100644
--- a/drivers/media/dvb-frontends/si21xx.c
+++ b/drivers/media/dvb-frontends/si21xx.c
@@ -8,7 +8,6 @@
 *	(at your option) any later version.
 *
 */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index 2aa8ef7..f5fc713 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -27,7 +27,6 @@
  */
 #define SP8870_DEFAULT_FIRMWARE "dvb-fe-sp8870.fw"
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
index 1bb81b5..f326955 100644
--- a/drivers/media/dvb-frontends/sp887x.c
+++ b/drivers/media/dvb-frontends/sp887x.c
@@ -10,7 +10,6 @@
  */
 #define SP887X_DEFAULT_FIRMWARE "dvb-fe-sp887x.fw"
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 07cd5ea..7fabfbd 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -19,7 +19,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index cea175d..4265e40 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -19,7 +19,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index 632b251..8731001 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -25,7 +25,6 @@
 
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
index d40f226..18903e5 100644
--- a/drivers/media/dvb-frontends/stv0297.c
+++ b/drivers/media/dvb-frontends/stv0297.c
@@ -19,7 +19,6 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index b57ecf4..baccefd 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -42,7 +42,6 @@
 
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 23e872f..9160cd1 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -19,7 +19,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index e66154e..9e1078e 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -20,7 +20,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/tda10021.c b/drivers/media/dvb-frontends/tda10021.c
index 1bff7f4..3558a54 100644
--- a/drivers/media/dvb-frontends/tda10021.c
+++ b/drivers/media/dvb-frontends/tda10021.c
@@ -23,7 +23,6 @@
 
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/tda10023.c b/drivers/media/dvb-frontends/tda10023.c
index ca1e0d5..f8193a5 100644
--- a/drivers/media/dvb-frontends/tda10023.c
+++ b/drivers/media/dvb-frontends/tda10023.c
@@ -27,7 +27,6 @@
 
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
index 71fb632..80adcb3 100644
--- a/drivers/media/dvb-frontends/tda10048.c
+++ b/drivers/media/dvb-frontends/tda10048.c
@@ -20,7 +20,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
index a2631be..d99a5dd 100644
--- a/drivers/media/dvb-frontends/tda1004x.c
+++ b/drivers/media/dvb-frontends/tda1004x.c
@@ -29,7 +29,6 @@
 #define TDA10045_DEFAULT_FIRMWARE "dvb-fe-tda10045.fw"
 #define TDA10046_DEFAULT_FIRMWARE "dvb-fe-tda10046.fw"
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/jiffies.h>
diff --git a/drivers/media/dvb-frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
index fcfe2e0..5d8ee20 100644
--- a/drivers/media/dvb-frontends/tda10086.c
+++ b/drivers/media/dvb-frontends/tda10086.c
@@ -20,7 +20,6 @@
 
    */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/jiffies.h>
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index 2c54586..2653c06 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -25,7 +25,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 63cc123..bf9f94b 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -17,7 +17,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
index 69e62f4..c5c1f59 100644
--- a/drivers/media/dvb-frontends/tda8083.c
+++ b/drivers/media/dvb-frontends/tda8083.c
@@ -24,7 +24,6 @@
 
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 19c4888..78ee1df 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -18,7 +18,6 @@
 */
 
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb-frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
index bb42b56..53090a5 100644
--- a/drivers/media/dvb-frontends/ves1820.c
+++ b/drivers/media/dvb-frontends/ves1820.c
@@ -20,7 +20,6 @@
 
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/dvb-frontends/ves1x93.c b/drivers/media/dvb-frontends/ves1x93.c
index 9c17eac..0cbaf19 100644
--- a/drivers/media/dvb-frontends/ves1x93.c
+++ b/drivers/media/dvb-frontends/ves1x93.c
@@ -25,7 +25,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index 91b6b2e..575ac33 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/dvb/frontend.h>
diff --git a/drivers/media/dvb-frontends/zl10353.c b/drivers/media/dvb-frontends/zl10353.c
index 82946cd..92cc0c3 100644
--- a/drivers/media/dvb-frontends/zl10353.c
+++ b/drivers/media/dvb-frontends/zl10353.c
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index d7d99f1..45db360 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index d45e0e3..c319584 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -21,7 +21,6 @@
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/types.h>
diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index d4e15a6..a3e207e 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/i2c/adv7393.c b/drivers/media/i2c/adv7393.c
index 558f191..a519aa5 100644
--- a/drivers/media/i2c/adv7393.c
+++ b/drivers/media/i2c/adv7393.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index c14e667..b8f395e 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 99ee456..f74e26b 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -36,7 +36,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index c3e94ae..830c84f 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -33,7 +33,6 @@
  * V1.1 Gerard v.d. Horst  Added some debugoutput, reset the video-standard
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index a9110d8..5775a6e 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -11,7 +11,6 @@
  * option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 85ec3ba..d20568b 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -22,7 +22,6 @@
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/module.h>
diff --git a/drivers/media/i2c/ov7640.c b/drivers/media/i2c/ov7640.c
index faa64ba..0171198 100644
--- a/drivers/media/i2c/ov7640.c
+++ b/drivers/media/i2c/ov7640.c
@@ -15,7 +15,6 @@
  * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e8a1ce2..8e45ba2 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -10,7 +10,6 @@
  * This file may be distributed under the terms of the GNU General
  * Public License, version 2.
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index e7f555c..56a979f 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -20,7 +20,6 @@
 #include <linux/firmware.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/media.h>
 #include <linux/module.h>
 #include <linux/regulator/consumer.h>
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c b/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
index 8001cde..e6a23a1 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
@@ -20,7 +20,6 @@
 #include <linux/firmware.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/media.h>
 #include <linux/module.h>
 #include <linux/regulator/consumer.h>
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
index 8079e26..09b3890 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -17,7 +17,6 @@
 
 #include <linux/sizes.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/media.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index 2960b5a..18c42ca 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -24,7 +24,6 @@
 #include <linux/i2c.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
diff --git a/drivers/media/i2c/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
index 8272c0b..234ea56 100644
--- a/drivers/media/i2c/saa6752hs.c
+++ b/drivers/media/i2c/saa6752hs.c
@@ -33,7 +33,6 @@
 #include <linux/i2c.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
-#include <linux/init.h>
 #include <linux/crc32.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/saa7110.c b/drivers/media/i2c/saa7110.c
index ac43e92..88d6cb9 100644
--- a/drivers/media/i2c/saa7110.c
+++ b/drivers/media/i2c/saa7110.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/saa7191.c b/drivers/media/i2c/saa7191.c
index 606a4ba..c129152 100644
--- a/drivers/media/i2c/saa7191.c
+++ b/drivers/media/i2c/saa7191.c
@@ -12,7 +12,6 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/module.h>
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 46f431a..00e014d 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -19,7 +19,6 @@
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/v4l2-mediabus.h>
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 6c6b1c3..5f2210b 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -13,7 +13,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 7f2b3c8..7bcbaac 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -15,7 +15,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index bc74224..28aac74 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -19,7 +19,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index ea76863..3dbd1ba 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -10,7 +10,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index ab54628..f35882b 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -16,7 +16,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/sony-btf-mpx.c b/drivers/media/i2c/sony-btf-mpx.c
index 32d8232..c2eede1 100644
--- a/drivers/media/i2c/sony-btf-mpx.c
+++ b/drivers/media/i2c/sony-btf-mpx.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
diff --git a/drivers/media/i2c/tda7432.c b/drivers/media/i2c/tda7432.c
index 72af644..ae5749d 100644
--- a/drivers/media/i2c/tda7432.c
+++ b/drivers/media/i2c/tda7432.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index d76c53a8..b17b484 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
diff --git a/drivers/media/i2c/tw2804.c b/drivers/media/i2c/tw2804.c
index f58607d..840067b 100644
--- a/drivers/media/i2c/tw2804.c
+++ b/drivers/media/i2c/tw2804.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
diff --git a/drivers/media/i2c/tw9903.c b/drivers/media/i2c/tw9903.c
index 285b759..8dde4c7 100644
--- a/drivers/media/i2c/tw9903.c
+++ b/drivers/media/i2c/tw9903.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
diff --git a/drivers/media/i2c/tw9906.c b/drivers/media/i2c/tw9906.c
index f6bef25..5ec7a8d 100644
--- a/drivers/media/i2c/tw9906.c
+++ b/drivers/media/i2c/tw9906.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
diff --git a/drivers/media/i2c/uda1342.c b/drivers/media/i2c/uda1342.c
index 081786d..2c20ac22 100644
--- a/drivers/media/i2c/uda1342.c
+++ b/drivers/media/i2c/uda1342.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index ece90df..32ceaf4 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/types.h>
 #include <linux/slab.h>
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 23f4f65..f8a80db 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -21,7 +21,6 @@
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/types.h>
diff --git a/drivers/media/pci/bt8xx/bttv-gpio.c b/drivers/media/pci/bt8xx/bttv-gpio.c
index 922e823..2cc95b1 100644
--- a/drivers/media/pci/bt8xx/bttv-gpio.c
+++ b/drivers/media/pci/bt8xx/bttv-gpio.c
@@ -29,7 +29,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/slab.h>
diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index d43911d..2d5c451 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -30,7 +30,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 
 #include "bttvp.h"
diff --git a/drivers/media/pci/bt8xx/bttv-if.c b/drivers/media/pci/bt8xx/bttv-if.c
index a6a540d..075eb78 100644
--- a/drivers/media/pci/bt8xx/bttv-if.c
+++ b/drivers/media/pci/bt8xx/bttv-if.c
@@ -27,7 +27,6 @@
 */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <asm/io.h>
 
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index f368213..1f17971 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -21,7 +21,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
diff --git a/drivers/media/pci/bt8xx/bttv-risc.c b/drivers/media/pci/bt8xx/bttv-risc.c
index 82cc47d..bcea329 100644
--- a/drivers/media/pci/bt8xx/bttv-risc.c
+++ b/drivers/media/pci/bt8xx/bttv-risc.c
@@ -27,7 +27,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 430b3eb..bbc901c 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 0e788fc..4e36cf6 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/dvb/ca.h>
diff --git a/drivers/media/pci/cx18/cx18-alsa-pcm.c b/drivers/media/pci/cx18/cx18-alsa-pcm.c
index 180077c..e65616d 100644
--- a/drivers/media/pci/cx18/cx18-alsa-pcm.c
+++ b/drivers/media/pci/cx18/cx18-alsa-pcm.c
@@ -23,7 +23,6 @@
  *  02111-1307  USA
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
 
diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
index 57f4688..57ef0d8 100644
--- a/drivers/media/pci/cx18/cx18-driver.h
+++ b/drivers/media/pci/cx18/cx18-driver.h
@@ -27,7 +27,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 95666ee..47313cf 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -26,7 +26,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/device.h>
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index c6c9bd5..771311a 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 79f20c8..0a2cd9f 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -19,7 +19,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 0549205..f1a563f 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/kthread.h>
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index 4887314..6d6345e 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -21,7 +21,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <asm/io.h>
 
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index a1154f0..332b40b 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 
 #include "cx23885.h"
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 7891f34..68bfee8 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -19,7 +19,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index b1e08c3..5f6b88b 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -23,7 +23,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 68dbc2d..0c7bb8c 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -28,7 +28,6 @@
 #include <linux/fs.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
diff --git a/drivers/media/pci/cx25821/cx25821-cards.c b/drivers/media/pci/cx25821/cx25821-cards.c
index f2ebc98..c35c71e 100644
--- a/drivers/media/pci/cx25821/cx25821-cards.c
+++ b/drivers/media/pci/cx25821/cx25821-cards.c
@@ -23,7 +23,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
index 1f43be0..db76689 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
@@ -27,7 +27,6 @@
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index ab63b38..79216c6 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -24,7 +24,6 @@
 #ifndef CX25821_VIDEO_H_
 #define CX25821_VIDEO_H_
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index d014206e..218f64a 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -25,7 +25,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index e18a7ac..7584afc 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -20,7 +20,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index ad59dc9..bf04477 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -25,7 +25,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
index cf2d696..4f80bb5 100644
--- a/drivers/media/pci/cx88/cx88-i2c.c
+++ b/drivers/media/pci/cx88/cx88-i2c.c
@@ -28,7 +28,6 @@
 */
 
 #include <linux/module.h>
-#include <linux/init.h>
 
 #include <asm/io.h>
 
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index f29e18c..9de7287 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -22,7 +22,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
-#include <linux/init.h>
 #include <linux/hrtimer.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 74b7b86..fb8e78f 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -24,7 +24,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
diff --git a/drivers/media/pci/cx88/cx88-tvaudio.c b/drivers/media/pci/cx88/cx88-tvaudio.c
index 424fd97..43c53b5 100644
--- a/drivers/media/pci/cx88/cx88-tvaudio.c
+++ b/drivers/media/pci/cx88/cx88-tvaudio.c
@@ -46,7 +46,6 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index f8f8389..2ea1190 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -2,7 +2,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 
 #include "cx88.h"
 
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index ed8cb90..7401bcb 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -25,7 +25,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kmod.h>
diff --git a/drivers/media/pci/cx88/cx88-vp3054-i2c.c b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
index deede6e..742bfca 100644
--- a/drivers/media/pci/cx88/cx88-vp3054-i2c.c
+++ b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
@@ -24,7 +24,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 
 #include <asm/io.h>
 
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index e60ac35..419194f 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -21,7 +21,6 @@
 
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index e1863db..9fd932b 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -23,7 +23,6 @@
  *  02111-1307  USA
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
 
diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index bc309f42c..408343a 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -37,7 +37,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
diff --git a/drivers/media/pci/mantis/mantis_pci.c b/drivers/media/pci/mantis/mantis_pci.c
index 9e89e04..fbf0182 100644
--- a/drivers/media/pci/mantis/mantis_pci.c
+++ b/drivers/media/pci/mantis/mantis_pci.c
@@ -25,7 +25,6 @@
 #include <asm/page.h>
 #include <linux/kmod.h>
 #include <linux/vmalloc.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/pci.h>
 
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 970e833..1eec301 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -28,7 +28,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/poll.h>
 #include <linux/io.h>
diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index fcb16a6..e94b4d5 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -28,7 +28,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
diff --git a/drivers/media/pci/ngene/ngene-i2c.c b/drivers/media/pci/ngene/ngene-i2c.c
index d28554f..434caf0 100644
--- a/drivers/media/pci/ngene/ngene-i2c.c
+++ b/drivers/media/pci/ngene/ngene-i2c.c
@@ -29,7 +29,6 @@
 
 /* FIXME - some of these can probably be removed */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index 655d6854..8293eb7 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -25,7 +25,6 @@
 
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index dd67c8a..33e22c1 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -16,7 +16,6 @@
  *
  */
 
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/wait.h>
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index d45e7f6..9ae7ca2 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -20,7 +20,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index c68169d..c71abff 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -20,7 +20,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 6f43126..255a35e 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 2e3f4b4..6957176 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -20,7 +20,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 0f34e09..ed532f4 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -20,7 +20,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index d4da18d..ce80d7c 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -20,7 +20,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index eb472b5..6d05685 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -20,7 +20,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/saa7164/saa7164-cards.c b/drivers/media/pci/saa7164/saa7164-cards.c
index 5b72da5..4698daa 100644
--- a/drivers/media/pci/saa7164/saa7164-cards.c
+++ b/drivers/media/pci/saa7164/saa7164-cards.c
@@ -19,7 +19,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
diff --git a/drivers/media/pci/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
index 4f7e3b4..a9a0c8d 100644
--- a/drivers/media/pci/saa7164/saa7164-i2c.c
+++ b/drivers/media/pci/saa7164/saa7164-i2c.c
@@ -21,7 +21,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 
diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
index 0e763a7..c77222d 100644
--- a/drivers/media/pci/ttpci/av7110_ir.c
+++ b/drivers/media/pci/ttpci/av7110_ir.c
@@ -23,7 +23,6 @@
 
 
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/ttpci/ttpci-eeprom.c b/drivers/media/pci/ttpci/ttpci-eeprom.c
index 32d4315..862552b 100644
--- a/drivers/media/pci/ttpci/ttpci-eeprom.c
+++ b/drivers/media/pci/ttpci/ttpci-eeprom.c
@@ -32,7 +32,6 @@
 */
 
 #include <asm/errno.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index e7e9840..6c4ab66 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -44,7 +44,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 2819165..119bc0a 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -22,7 +22,6 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/mm.h>
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 33b9660..fb86341 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -15,7 +15,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index b02aba4..7d73561 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -11,7 +11,6 @@
  * GNU General Public License for more details.
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index 14a023a..62a4cd3 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -16,7 +16,6 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/device.h>
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index d762246..3253714 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -68,7 +68,6 @@
  */
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index dbf0ce3..9a6c4c0 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -18,7 +18,6 @@
 #include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
diff --git a/drivers/media/platform/indycam.c b/drivers/media/platform/indycam.c
index f1d192b..27c0669 100644
--- a/drivers/media/platform/indycam.c
+++ b/drivers/media/platform/indycam.c
@@ -12,7 +12,6 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/module.h>
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index e5f1d4c..42c4b90 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -13,7 +13,6 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 4835173..78240a6 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -15,7 +15,6 @@
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index d73abca..ac9af48 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -11,7 +11,6 @@
  * (at your option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index f975b70..0e915db 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -9,7 +9,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/videodev2.h>
 #include <linux/platform_device.h>
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d4df305..f918282 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -10,7 +10,6 @@
  * (at your option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4b8c024..197fbdf 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -19,7 +19,6 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index ceaddfb..54fbe90 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -10,7 +10,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 142c2ee..8cfe33e 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -36,7 +36,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index 6ff3508..c7d2d7a 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index a85b064..f4ae0f6 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -22,7 +22,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 5236035..996125d 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -34,7 +34,6 @@
 
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index a360227..4e57439 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -56,7 +56,6 @@
 /* kernel includes */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/radio/radio-raremono.c b/drivers/media/radio/radio-raremono.c
index 7b3bdbb..b27b4d5 100644
--- a/drivers/media/radio/radio-raremono.c
+++ b/drivers/media/radio/radio-raremono.c
@@ -17,7 +17,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 050b3bb..c824eb3 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -25,7 +25,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/module.h>
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index 8654e0d..5318fe3 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -25,7 +25,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/module.h>
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 3ed1f56..e491990 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -34,7 +34,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>			/* Initdata			*/
 #include <linux/videodev2.h>		/* kernel radio structs		*/
 #include <linux/i2c.h>			/* I2C				*/
 #include <media/v4l2-common.h>
diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
index e245597..18aae8e 100644
--- a/drivers/media/radio/radio-tea5777.c
+++ b/drivers/media/radio/radio-tea5777.c
@@ -24,7 +24,6 @@
  */
 
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index ec805b0..4f1ce57 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 4b76604..20c3849 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -28,7 +28,6 @@
 /* kernel includes */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/input.h>
diff --git a/drivers/media/radio/si4713/radio-platform-si4713.c b/drivers/media/radio/si4713/radio-platform-si4713.c
index ba4cfc9..139ff48 100644
--- a/drivers/media/radio/si4713/radio-platform-si4713.c
+++ b/drivers/media/radio/si4713/radio-platform-si4713.c
@@ -23,7 +23,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index f1e640d..03df453 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/mutex.h>
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index a9319a2..e62cad6 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 4d6a63f..fecbed4 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -88,7 +88,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 80c611c..d8481d8 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 822b9f4..639d346 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -29,7 +29,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 20cca40..b48fc4c 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -19,7 +19,6 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
index b473b76..1ebf69c 100644
--- a/drivers/media/tuners/mxl5005s.c
+++ b/drivers/media/tuners/mxl5005s.c
@@ -58,7 +58,6 @@
       respective owners.
 */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/drivers/media/tuners/tda9887.c b/drivers/media/tuners/tda9887.c
index 9823248..97afd7b 100644
--- a/drivers/media/tuners/tda9887.c
+++ b/drivers/media/tuners/tda9887.c
@@ -2,7 +2,6 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 19fe049..5428825 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -21,7 +21,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/usb/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
index 17ec365..ae18b7b 100644
--- a/drivers/media/usb/au0828/au0828-i2c.c
+++ b/drivers/media/usb/au0828/au0828-i2c.c
@@ -21,7 +21,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index 63f5930..4373d3c 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -23,7 +23,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 
 #include "au0828.h"
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index f615454..0bb104e 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -30,7 +30,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 2f63029..e16a00b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -26,7 +26,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/device.h>
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 89de00b..43db655 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -22,7 +22,6 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 2ee03e4..4da2cf3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -20,7 +20,6 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 4ba3ce0..9040a24 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -20,7 +20,6 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
index b3c6190..88206a0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
@@ -22,7 +22,6 @@
 #ifndef _PCB_CONFIG_H_
 #define _PCB_CONFIG_H_
 
-#include <linux/init.h>
 #include <linux/module.h>
 
 /***************************************************************************
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index c027942..d95aa4f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -19,7 +19,6 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 9906261..d91d3e1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -22,7 +22,6 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index d56f927..4467e37 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -10,7 +10,6 @@
  *
  * see Documentation/dvb/README.dvb-usb for more information
  */
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6efb902..fc68d17 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -23,7 +23,6 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index b6dc332..382bf19 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -22,7 +22,6 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/list.h>
 #include <linux/module.h>
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index db3d655..0cc4759 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -24,7 +24,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
-#include <linux/init.h>
 
 #include "em28xx.h"
 #include "em28xx-v4l.h"
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index a1dcceb..3d7f909 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -26,7 +26,6 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
index 6053661..d0f0791 100644
--- a/drivers/media/usb/hdpvr/hdpvr-control.c
+++ b/drivers/media/usb/hdpvr/hdpvr-control.c
@@ -11,7 +11,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb.h>
diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 2f0c89c..04e471e 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 0500c417..736aba4 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/kconfig.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index abf365a..b045645 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -58,7 +58,6 @@
 */
 
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/poll.h>
diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index aa7449e..6fcbac8 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -27,7 +27,6 @@
 */
 
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/poll.h>
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 05bd91a..84303a9 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -20,7 +20,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ****************************************************************/
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 34a26e0..99b2f30 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -26,7 +26,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index be77482..18bc392 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/media/usb/tlg2300/pd-alsa.c b/drivers/media/usb/tlg2300/pd-alsa.c
index 3f3e141..e0f51e1 100644
--- a/drivers/media/usb/tlg2300/pd-alsa.c
+++ b/drivers/media/usb/tlg2300/pd-alsa.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/usb.h>
-#include <linux/init.h>
 #include <linux/sound.h>
 #include <linux/spinlock.h>
 #include <linux/soundcard.h>
diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index ea6070b..13a57c2 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -1,4 +1,3 @@
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 1ccaadd..88baf37 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -17,7 +17,6 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 8a6bbf1..926ba06 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 
 #include <linux/input.h>
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index cc1aa14..ec88656 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/random.h>
 #include <linux/usb.h>
diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index f8a60c1..aa643df 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -9,7 +9,6 @@
  *	published by the Free Software Foundation; either version 2 of
  *	the License, or (at your option) any later version.
  */
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/fs.h>
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 29724af..94c5051 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -29,7 +29,6 @@
 #include <linux/interrupt.h>
 #include <linux/firmware.h>
 #include <linux/crc32.h>
-#include <linux/init.h>
 #include <linux/input.h>
 
 #include <linux/mutex.h>
diff --git a/drivers/media/usb/usbtv/usbtv.c b/drivers/media/usb/usbtv/usbtv.c
index 6222a4a..80262e1 100644
--- a/drivers/media/usb/usbtv/usbtv.c
+++ b/drivers/media/usb/usbtv/usbtv.c
@@ -28,7 +28,6 @@
  * GNU General Public License ("GPL").
  */
 
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 816b1cf..191dd2b 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -31,7 +31,6 @@
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/usb/usbvision/usbvision-i2c.c b/drivers/media/usb/usbvision/usbvision-i2c.c
index ba262a3..ae1a1e6 100644
--- a/drivers/media/usb/usbvision/usbvision-i2c.c
+++ b/drivers/media/usb/usbvision/usbvision-i2c.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
 #include <linux/errno.h>
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 74d56df..764c655e 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -29,7 +29,6 @@
 
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 20c0922..f9f6d71 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -24,7 +24,6 @@
 #include <linux/poll.h>
 #include <linux/i2c.h>
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
 #include <media/tuner-types.h>
diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index fb5ee5d..b837626 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -13,7 +13,6 @@
  * the Free Software Foundation; either version 2
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/mm.h>
diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index 65411ad..557d42e 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -14,7 +14,6 @@
  * the Free Software Foundation; either version 2
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 9db674c..20c4849 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -18,7 +18,6 @@
  * the Free Software Foundation; either version 2
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
diff --git a/drivers/media/v4l2-core/videobuf-dvb.c b/drivers/media/v4l2-core/videobuf-dvb.c
index b7efa45..210a7cb 100644
--- a/drivers/media/v4l2-core/videobuf-dvb.c
+++ b/drivers/media/v4l2-core/videobuf-dvb.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/kthread.h>
diff --git a/drivers/media/v4l2-core/videobuf-vmalloc.c b/drivers/media/v4l2-core/videobuf-vmalloc.c
index 1365c65..8c524fd 100644
--- a/drivers/media/v4l2-core/videobuf-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf-vmalloc.c
@@ -13,7 +13,6 @@
  * the Free Software Foundation; either version 2
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
-- 
1.8.4.1

