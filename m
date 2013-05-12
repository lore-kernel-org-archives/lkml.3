Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3ELUoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 16:44:11 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:43873 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3ELUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 16:44:10 -0400
Date: Sun, 12 May 2013 22:44:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v3.10-rc1 (cris)
In-Reply-To: <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1305122242430.5463@ayla.of.borg>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg> <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 May 2013, Geert Uytterhoeven wrote:
> However, the full list of errors isn't that unmanageable, so I'm following
> up with a digested list...

arch/cris/arch-v10/kernel/kgdb.c:1273:1: error: missing terminating " character: 2 errors in 2 logs
arch/cris/arch-v10/kernel/kgdb.c:1274:3: error: expected string literal before '.' token: 2 errors in 2 logs
arch/cris/arch-v10/kernel/kgdb.c:1359:1: error: missing terminating " character: 2 errors in 2 logs
arch/cris/arch-v10/kernel/kgdb.c:1370:1: error: missing terminating " character: 2 errors in 2 logs
arch/cris/arch-v10/kernel/kgdb.c:1457:1: error: missing terminating " character: 2 errors in 2 logs
	v3.10-rc1/cris/cris-allmodconfig v3.10-rc1/cris/cris-allyesconfig

	Patch series sent last February


drivers/video/console/fonts.c:71:2: error: #error No fonts configured.: 2 errors in 2 logs
	v3.10-rc1/cris/cris-allmodconfig v3.10-rc1/cris/cris-allyesconfig

	Fbdev issue?


net/mac80211/led.c:101:19: error: 'struct led_trigger' has no member named 'name': 2 errors in 2 logs
net/mac80211/led.c:119:3: error: implicit declaration of function 'led_trigger_unregister' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
net/mac80211/led.c:213:2: error: 'struct led_trigger' has no member named 'leddev_list_lock': 2 errors in 2 logs
net/mac80211/led.c:214:2: error: 'struct led_classdev' has no member named 'trig_list': 12 errors in 2 logs
net/mac80211/led.c:214:2: error: 'struct led_trigger' has no member named 'led_cdevs': 4 errors in 2 logs
net/mac80211/led.c:216:2: error: 'struct led_trigger' has no member named 'leddev_list_lock': 2 errors in 2 logs
net/mac80211/led.c:237:16: error: 'struct led_trigger' has no member named 'name': 2 errors in 2 logs
net/mac80211/led.c:277:2: error: 'struct led_trigger' has no member named 'leddev_list_lock': 2 errors in 2 logs
net/mac80211/led.c:278:2: error: 'struct led_classdev' has no member named 'trig_list': 12 errors in 2 logs
net/mac80211/led.c:278:2: error: 'struct led_trigger' has no member named 'led_cdevs': 4 errors in 2 logs
net/mac80211/led.c:280:2: error: 'struct led_trigger' has no member named 'leddev_list_lock': 2 errors in 2 logs
net/mac80211/led.c:74:16: error: 'struct led_trigger' has no member named 'name': 2 errors in 2 logs
net/mac80211/led.c:75:3: error: implicit declaration of function 'led_trigger_register' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
net/mac80211/led.c:83:16: error: 'struct led_trigger' has no member named 'name': 2 errors in 2 logs
net/mac80211/led.c:92:19: error: 'struct led_trigger' has no member named 'name': 2 errors in 2 logs
No rule to make target arch/cris/arch-v10/drivers/ds1302.o: 2 errors in 2 logs
	v3.10-rc1/cris/cris-allmodconfig v3.10-rc1/cris/cris-allyesconfig

	LED dependency issue?


drivers/block/hd.c:256:2: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/block/hd.c:297:3: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-ocores.c:101:2: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-ocores.c:106:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-ocores.c:81:2: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-ocores.c:86:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-ocores.c:91:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-ocores.c:96:2: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-pca-platform.c:46:2: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-pca-platform.c:64:2: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-xiic.c:179:2: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-xiic.c:184:2: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-xiic.c:189:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-xiic.c:194:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/i2c/busses/i2c-xiic.c:199:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/input/serio/arc_ps2.c:101:4: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/input/serio/arc_ps2.c:57:3: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/mtd/nand/denali.c:107:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/mtd/nand/denali.c:116:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/cc770/cc770_platform.c:69:2: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/cc770/cc770_platform.c:75:2: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/sja1000/sja1000_platform.c:42:2: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/sja1000/sja1000_platform.c:47:2: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/softing/softing_fw.c:295:3: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/softing/softing_fw.c:369:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/softing/softing_fw.c:37:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/softing/softing_fw.c:38:2: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/softing/softing_fw.c:46:3: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/softing/softing_fw.c:52:4: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/softing/softing_main.c:47:3: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/can/softing/softing_main.c:47:3: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/ethoc.c:234:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/ethoc.c:239:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/micrel/ks8851_mll.c:487:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/micrel/ks8851_mll.c:488:2: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/micrel/ks8851_mll.c:757:3: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/wiznet/w5100.c:122:2: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/wiznet/w5100.c:128:2: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/wiznet/w5300.c:118:2: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/ethernet/wiznet/w5300.c:124:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/wireless/ath/ath9k/init.c:190:3: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/net/wireless/ath/ath9k/init.c:206:3: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/serialio.c:199:3: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/serialio.c:83:2: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_acntpc.c:144:2: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_acntpc.c:166:3: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_decext.c:41:2: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_decpc.c:249:2: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_decpc.c:256:2: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_dtlk.c:158:2: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_dtlk.c:182:2: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_dtlk.c:362:2: error: implicit declaration of function 'inw_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_keypc.c:135:2: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/speakup_keypc.c:167:3: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/staging/speakup/synth.c:45:4: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/tty/serial/8250/8250_core.c:1231:3: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/tty/serial/8250/8250_core.c:1232:3: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/tty/serial/timbuart.c:54:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/tty/serial/timbuart.c:55:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/tty/serial/timbuart.c:84:3: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/tty/serial/timbuart.c:87:3: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/chipidea/ci.h:247:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 8 errors in 2 logs
drivers/usb/chipidea/ci.h:263:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 8 errors in 2 logs
drivers/usb/gadget/fusb300_udc.c:42:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/fusb300_udc.c:45:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/m66592-udc.h:526:2: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/m66592-udc.h:537:3: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/m66592-udc.h:540:3: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/m66592-udc.h:547:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/m66592-udc.h:577:3: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/m66592-udc.h:583:6: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/m66592-udc.h:592:3: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/mv_u3d_core.c:70:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/mv_u3d_core.c:72:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:127:2: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:144:4: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:152:5: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:161:4: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:179:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:209:4: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:216:4: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:233:3: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/gadget/r8a66597-udc.h:269:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/host/r8a66597.h:168:2: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/host/r8a66597.h:180:3: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/host/r8a66597.h:183:4: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/host/r8a66597.h:189:3: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/host/r8a66597.h:196:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/host/r8a66597.h:225:3: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/host/r8a66597.h:231:6: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/host/r8a66597.h:240:3: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/musb/tusb6010.c:202:5: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/musb/tusb6010.c:249:5: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/phy/phy-rcar-usb.c:75:3: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/phy/phy-rcar-usb.c:83:4: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/renesas_usbhs/common.c:73:2: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/renesas_usbhs/common.c:78:2: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/renesas_usbhs/fifo.c:519:3: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/renesas_usbhs/fifo.c:526:3: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/renesas_usbhs/fifo.c:666:3: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
drivers/usb/renesas_usbhs/fifo.c:674:4: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
	v3.10-rc1/cris/cris-allmodconfig v3.10-rc1/cris/cris-allyesconfig
drivers/usb/musb/musb_core.c:254:5: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
drivers/usb/musb/musb_core.c:263:5: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
drivers/usb/musb/musb_core.c:271:3: error: implicit declaration of function 'iowrite8_rep' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
drivers/usb/musb/musb_core.c:297:5: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
drivers/usb/musb/musb_core.c:306:5: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
drivers/usb/musb/musb_core.c:314:3: error: implicit declaration of function 'ioread8_rep' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
	v3.10-rc1/cris/cris-allmodconfig

	Missing I/O ops

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
