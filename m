Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaAXQb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:31:58 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34517 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaAXQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:31:54 -0500
Date: Fri, 24 Jan 2014 08:31:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.14-rc0
Message-ID: <20140124163146.GA1977@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive first round of updates for the input subsystem. Just a swath
of driver fixes and cleanups, no new drivers this time (although ALPS
now supports one of the newer protocols, more to come).

Changelog:
---------

Aleksej Makarov (1):
      Input: don't call input_dev_release_keys() in resume

Alexander Shiyan (1):
      Input: add a new driver for GPIO beeper

Antonio Ospite (3):
      Input: joystick - refer to /dev/input/js0 in documentation
      Input: joystick - use sizeof(VARIABLE) in documentation
      Input: fix typos in Documentation/input/gamepad.txt

Denis Carikli (1):
      Input: tsc2007 - add device tree support.

Dmitry Torokhov (6):
      Input: tsc2007 - remove unused poll_delay from platform data
      Input: tsc2007 - convert to use devres-managed resources
      Input: samsung-keypad - favor platform data if present
      Input: pmic8xxx-pwrkey - switch to using managed resources
      Input: twl6040-vibra - remove unneeded check for CONFIG_OF
      Input: twl4030-keypad - convert to using managed resources

Doug Anderson (1):
      Input: cros_ec_keyb - fix problems with backslash

Fabio Estevam (1):
      Input: ads7846 - use IS_ENABLED() macro

Geert Uytterhoeven (1):
      Input: logips2pp - fix spelling s/reciver/receiver/

Guenter Roeck (1):
      Input: ads7846 - convert to hwmon_device_register_with_groups()

Hans de Goede (1):
      Input: elantech -  improve clickpad detection

Jason Gerecke (1):
      Input: wacom - scale up touch width and height values for Intuos Pro

Jingoo Han (2):
      Input: serio - remove unnecessary pci_set_drvdata()
      Input: use dev_get_platdata()

K. Y. Srinivasan (1):
      Input: hyperv-keyboard - pass through 0xE1 prefix

Laurent Pinchart (1):
      Input: sh_keysc - restrict non-COMPILE_TEST compilation

Libo Chen (2):
      Input: twl4030-vibra - add missing of_node_put
      Input: twl6040-vibra - add missing of_node_put

Lothar Wa=DFmann (1):
      Input: edt_ft5x06 - use devm_* functions where appropriate

Mark Salter (10):
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO on alpha
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO on ARM/Footbridge
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO on IA64
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO on mips
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO on powerpc
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO for SH_CAYMAN
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO on sparc
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO on unicore32
      Input: i8042 - select ARCH_MIGHT_HAVE_PC_SERIO on x86
      Input: i8042 - cleanup SERIO_I8042 dependencies

Paul Gortmaker (1):
      Input: delete non-required instances of include <linux/init.h>

Petr Sebor (1):
      Input: xpad - add new USB IDs for Logitech F310 and F710

Ping Cheng (5):
      Input: wacom - make sure touch_max is set for touch devices
      Input: wacom - add support for three new Intuos devices
      Input: wacom - add reporting of SW_MUTE_DEVICE events
      Input: wacom - fix wacom->shared guards for dual input devices
      Input: wacom - add support for DTU-1031

Rashika Kheria (1):
      Input: cyttsp - include appropriate header file in cyttsp_i2c_common.c

Sachin Kamat (2):
      Input: keypad-ep93xx - cleanup header file
      Input: keypad-omap - cleanup header file

Sebastian Reichel (4):
      Input: twl4030-pwrbutton - add device tree support
      Input: twl4030-pwrbutton - use dev_err for errors
      Input: twl4030-pwrbutton - simplify driver using devm_*
      Input: twl4030-keypad - add device tree support

Stephen Boyd (4):
      Input: pm8xxx-vibrator - switch to using managed resources
      Input: pm8xxx-vibrator - migrate to regmap APIs
      Input: pmic8xxx-pwrkey - pass input device directly to interrupt
      Input: pmic8xxx-pwrkey - migrate to regmap APIs

Thomaz de Oliveira dos Reis (1):
      Input: xpad - change D-PAD mapping on Razer devices

Wei Yongjun (2):
      Input: zforce - fix error return code in zforce_start()
      Input: pmic8xxx-pwrkey - pass correct device identity to free_irq()

Yunkang Tang (1):
      Input: ALPS - add support for "Dolphin" devices


Diffstat:
--------

 .../devicetree/bindings/input/gpio-beeper.txt      |  13 ++
 .../bindings/input/touchscreen/tsc2007.txt         |  41 ++++
 .../devicetree/bindings/input/twl4030-keypad.txt   |  27 +++
 .../bindings/input/twl4030-pwrbutton.txt           |  21 ++
 Documentation/input/gamepad.txt                    |   6 +-
 Documentation/input/joystick-api.txt               |  38 ++--
 Documentation/input/joystick.txt                   |   8 +-
 arch/alpha/Kconfig                                 |   1 +
 arch/arm/mach-footbridge/Kconfig                   |   1 +
 arch/arm/mach-imx/mach-cpuimx35.c                  |   2 +-
 arch/arm/mach-imx/mach-cpuimx51sd.c                |   2 +-
 arch/ia64/Kconfig                                  |   1 +
 arch/mips/Kconfig                                  |   1 +
 arch/powerpc/Kconfig                               |   1 +
 arch/sh/boards/Kconfig                             |   1 +
 arch/sh/boards/mach-ecovec24/setup.c               |   2 +-
 arch/sparc/Kconfig                                 |   1 +
 arch/unicore32/Kconfig                             |   1 +
 arch/x86/Kconfig                                   |   1 +
 drivers/input/gameport/emu10k1-gp.c                |   1 -
 drivers/input/gameport/fm801-gp.c                  |   1 -
 drivers/input/input.c                              |  76 +++++--
 drivers/input/joystick/a3d.c                       |   1 -
 drivers/input/joystick/adi.c                       |   1 -
 drivers/input/joystick/cobra.c                     |   1 -
 drivers/input/joystick/gf2k.c                      |   1 -
 drivers/input/joystick/grip.c                      |   1 -
 drivers/input/joystick/grip_mp.c                   |   1 -
 drivers/input/joystick/guillemot.c                 |   1 -
 drivers/input/joystick/iforce/iforce.h             |   1 -
 drivers/input/joystick/interact.c                  |   1 -
 drivers/input/joystick/joydump.c                   |   1 -
 drivers/input/joystick/magellan.c                  |   1 -
 drivers/input/joystick/sidewinder.c                |   1 -
 drivers/input/joystick/spaceball.c                 |   1 -
 drivers/input/joystick/spaceorb.c                  |   1 -
 drivers/input/joystick/stinger.c                   |   1 -
 drivers/input/joystick/tmdc.c                      |   1 -
 drivers/input/joystick/twidjoy.c                   |   1 -
 drivers/input/joystick/warrior.c                   |   1 -
 drivers/input/joystick/xpad.c                      |   7 +-
 drivers/input/joystick/zhenhua.c                   |   1 -
 drivers/input/keyboard/Kconfig                     |   2 +-
 drivers/input/keyboard/adp5520-keys.c              |   3 +-
 drivers/input/keyboard/adp5588-keys.c              |  11 +-
 drivers/input/keyboard/adp5589-keys.c              |   9 +-
 drivers/input/keyboard/bf54x-keys.c                |   5 +-
 drivers/input/keyboard/cros_ec_keyb.c              |  15 +-
 drivers/input/keyboard/davinci_keyscan.c           |   2 +-
 drivers/input/keyboard/ep93xx_keypad.c             |   2 +-
 drivers/input/keyboard/goldfish_events.c           |   1 -
 drivers/input/keyboard/gpio_keys_polled.c          |   1 -
 drivers/input/keyboard/hil_kbd.c                   |   1 -
 drivers/input/keyboard/imx_keypad.c                |   4 +-
 drivers/input/keyboard/jornada680_kbd.c            |   1 -
 drivers/input/keyboard/jornada720_kbd.c            |   1 -
 drivers/input/keyboard/lkkbd.c                     |   1 -
 drivers/input/keyboard/lm8323.c                    |   2 +-
 drivers/input/keyboard/lm8333.c                    |   3 +-
 drivers/input/keyboard/matrix_keypad.c             |   1 -
 drivers/input/keyboard/max7359_keypad.c            |   3 +-
 drivers/input/keyboard/mcs_touchkey.c              |   3 +-
 drivers/input/keyboard/mpr121_touchkey.c           |   4 +-
 drivers/input/keyboard/newtonkbd.c                 |   1 -
 drivers/input/keyboard/nomadik-ske-keypad.c        |   3 +-
 drivers/input/keyboard/omap-keypad.c               |   3 +-
 drivers/input/keyboard/omap4-keypad.c              |   1 -
 drivers/input/keyboard/pxa27x_keypad.c             |   1 -
 drivers/input/keyboard/pxa930_rotary.c             |   4 +-
 drivers/input/keyboard/qt1070.c                    |   1 -
 drivers/input/keyboard/qt2160.c                    |   1 -
 drivers/input/keyboard/samsung-keypad.c            |  37 ++--
 drivers/input/keyboard/sh_keysc.c                  |   5 +-
 drivers/input/keyboard/spear-keyboard.c            |   1 -
 drivers/input/keyboard/stmpe-keypad.c              |   1 -
 drivers/input/keyboard/stowaway.c                  |   1 -
 drivers/input/keyboard/sunkbd.c                    |   1 -
 drivers/input/keyboard/tc3589x-keypad.c            |   1 -
 drivers/input/keyboard/tca6416-keypad.c            |   2 +-
 drivers/input/keyboard/tnetv107x-keypad.c          |   2 +-
 drivers/input/keyboard/twl4030_keypad.c            | 122 +++++------
 drivers/input/keyboard/w90p910_keypad.c            |   3 +-
 drivers/input/keyboard/xtkbd.c                     |   1 -
 drivers/input/misc/Kconfig                         |   9 +
 drivers/input/misc/Makefile                        |   1 +
 drivers/input/misc/ad714x.c                        |   5 +-
 drivers/input/misc/adxl34x.c                       |   3 +-
 drivers/input/misc/atlas_btns.c                    |   1 -
 drivers/input/misc/bfin_rotary.c                   |   3 +-
 drivers/input/misc/bma150.c                        |   3 +-
 drivers/input/misc/cma3000_d0x.c                   |   2 +-
 drivers/input/misc/cobalt_btns.c                   |   1 -
 drivers/input/misc/da9052_onkey.c                  |   1 -
 drivers/input/misc/da9055_onkey.c                  |   1 -
 drivers/input/misc/dm355evm_keys.c                 |   1 -
 drivers/input/misc/gp2ap002a00f.c                  |   2 +-
 drivers/input/misc/gpio-beeper.c                   | 127 ++++++++++++
 drivers/input/misc/gpio_tilt_polled.c              |   4 +-
 drivers/input/misc/keyspan_remote.c                |   1 -
 drivers/input/misc/kxtj9.c                         |   3 +-
 drivers/input/misc/max8997_haptic.c                |   1 -
 drivers/input/misc/mc13783-pwrbutton.c             |   1 -
 drivers/input/misc/mpu3050.c                       |   1 -
 drivers/input/misc/pcap_keys.c                     |   1 -
 drivers/input/misc/pcf50633-input.c                |   1 -
 drivers/input/misc/pcf8574_keypad.c                |   1 -
 drivers/input/misc/pcspkr.c                        |   1 -
 drivers/input/misc/pm8xxx-vibrator.c               | 107 +++-------
 drivers/input/misc/pmic8xxx-pwrkey.c               | 106 ++++------
 drivers/input/misc/powermate.c                     |   1 -
 drivers/input/misc/pwm-beeper.c                    |   2 +-
 drivers/input/misc/retu-pwrbutton.c                |   1 -
 drivers/input/misc/rotary_encoder.c                |   1 -
 drivers/input/misc/sgi_btns.c                      |   1 -
 drivers/input/misc/sirfsoc-onkey.c                 |   1 -
 drivers/input/misc/twl4030-pwrbutton.c             |  46 ++---
 drivers/input/misc/twl4030-vibra.c                 |   6 +-
 drivers/input/misc/twl6040-vibra.c                 |   8 +-
 drivers/input/misc/wm831x-on.c                     |   1 -
 drivers/input/misc/yealink.c                       |   1 -
 drivers/input/mouse/alps.c                         | 214 +++++++++++++++--=
--
 drivers/input/mouse/alps.h                         |   7 +-
 drivers/input/mouse/appletouch.c                   |   1 -
 drivers/input/mouse/bcm5974.c                      |   1 -
 drivers/input/mouse/cypress_ps2.c                  |   1 -
 drivers/input/mouse/elantech.c                     |  45 +++-
 drivers/input/mouse/gpio_mouse.c                   |   3 +-
 drivers/input/mouse/logips2pp.c                    |   2 +-
 drivers/input/mouse/navpoint.c                     |   1 -
 drivers/input/mouse/pxa930_trkball.c               |   3 +-
 drivers/input/mouse/sermouse.c                     |   1 -
 drivers/input/mouse/synaptics_usb.c                |   1 -
 drivers/input/mouse/vsxxxaa.c                      |   1 -
 drivers/input/serio/Kconfig                        |  11 +-
 drivers/input/serio/altera_ps2.c                   |   1 -
 drivers/input/serio/ambakmi.c                      |   1 -
 drivers/input/serio/hyperv-keyboard.c              |   4 +-
 drivers/input/serio/libps2.c                       |   1 -
 drivers/input/serio/olpc_apsp.c                    |   1 -
 drivers/input/serio/pcips2.c                       |   2 -
 drivers/input/serio/q40kbd.c                       |   1 -
 drivers/input/serio/rpckbd.c                       |   1 -
 drivers/input/serio/serio_raw.c                    |   1 -
 drivers/input/serio/xilinx_ps2.c                   |   1 -
 drivers/input/tablet/acecad.c                      |   1 -
 drivers/input/tablet/aiptek.c                      |   1 -
 drivers/input/tablet/gtco.c                        |   1 -
 drivers/input/tablet/hanwang.c                     |   1 -
 drivers/input/tablet/kbtab.c                       |   1 -
 drivers/input/tablet/wacom.h                       |   1 -
 drivers/input/tablet/wacom_sys.c                   |  23 ++-
 drivers/input/tablet/wacom_wac.c                   | 169 +++++++++++++--
 drivers/input/tablet/wacom_wac.h                   |  13 +-
 drivers/input/touchscreen/88pm860x-ts.c            |   2 +-
 drivers/input/touchscreen/ad7877.c                 |   3 +-
 drivers/input/touchscreen/ad7879.c                 |   5 +-
 drivers/input/touchscreen/ads7846.c                |  86 +++-----
 drivers/input/touchscreen/atmel_mxt_ts.c           |   3 +-
 drivers/input/touchscreen/atmel_tsadcc.c           |   3 +-
 drivers/input/touchscreen/cy8ctmg110_ts.c          |   2 +-
 drivers/input/touchscreen/cyttsp_core.c            |   4 +-
 drivers/input/touchscreen/cyttsp_i2c_common.c      |   2 +
 drivers/input/touchscreen/da9034-ts.c              |   3 +-
 drivers/input/touchscreen/dynapro.c                |   1 -
 drivers/input/touchscreen/edt-ft5x06.c             |  71 +++----
 drivers/input/touchscreen/eeti_ts.c                |   2 +-
 drivers/input/touchscreen/egalax_ts.c              |   1 -
 drivers/input/touchscreen/elo.c                    |   1 -
 drivers/input/touchscreen/fujitsu_ts.c             |   1 -
 drivers/input/touchscreen/gunze.c                  |   1 -
 drivers/input/touchscreen/hampshire.c              |   1 -
 drivers/input/touchscreen/ili210x.c                |   2 +-
 drivers/input/touchscreen/inexio.c                 |   1 -
 drivers/input/touchscreen/intel-mid-touch.c        |   1 -
 drivers/input/touchscreen/jornada720_ts.c          |   1 -
 drivers/input/touchscreen/lpc32xx_ts.c             |   1 -
 drivers/input/touchscreen/mainstone-wm97xx.c       |   1 -
 drivers/input/touchscreen/max11801_ts.c            |   1 -
 drivers/input/touchscreen/mcs5000_ts.c             |   5 +-
 drivers/input/touchscreen/mms114.c                 |   1 -
 drivers/input/touchscreen/mtouch.c                 |   1 -
 drivers/input/touchscreen/pcap_ts.c                |   1 -
 drivers/input/touchscreen/penmount.c               |   1 -
 drivers/input/touchscreen/pixcir_i2c_ts.c          |   3 +-
 drivers/input/touchscreen/s3c2410_ts.c             |   5 +-
 drivers/input/touchscreen/st1232.c                 |   2 +-
 drivers/input/touchscreen/stmpe-ts.c               |   1 -
 drivers/input/touchscreen/ti_am335x_tsc.c          |   1 -
 drivers/input/touchscreen/touchit213.c             |   1 -
 drivers/input/touchscreen/touchright.c             |   1 -
 drivers/input/touchscreen/touchwin.c               |   1 -
 drivers/input/touchscreen/tsc2005.c                |   2 +-
 drivers/input/touchscreen/tsc2007.c                | 230 ++++++++++++++---=
----
 drivers/input/touchscreen/tsc40.c                  |   1 -
 drivers/input/touchscreen/ucb1400_ts.c             |   9 +-
 drivers/input/touchscreen/usbtouchscreen.c         |   1 -
 drivers/input/touchscreen/wacom_w8001.c            |   1 -
 drivers/input/touchscreen/wm831x-ts.c              |   1 -
 drivers/input/touchscreen/wm97xx-core.c            |   2 +-
 drivers/input/touchscreen/zforce_ts.c              |   3 +-
 drivers/input/touchscreen/zylonite-wm97xx.c        |   1 -
 include/linux/i2c/tsc2007.h                        |   8 +-
 include/linux/platform_data/keypad-ep93xx.h        |  10 +-
 include/linux/platform_data/keypad-omap.h          |   6 +-
 204 files changed, 1245 insertions(+), 768 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/gpio-beeper.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/tsc=
2007.txt
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-keypad.=
txt
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-pwrbutt=
on.txt
 create mode 100644 drivers/input/misc/gpio-beeper.c


--=20
Dmitry


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS4pVyAAoJEH70+W8r6ZYqzQ0P/0/wywWx7Z+jSV3Acdi4rqml
QASQX9QVW3tk10A5akFDxoquX6/VixSbfY9YKCjMyU1yOy/KCQiSK7vwd7PCIjQB
VDEnssDOXL7E5Wi5g6NXZKM63Znx1IV3NqYLgTqFySIZ9WlqR9sOxWEUI4RgBIX2
dk7eb8V0QyCuQ55ahuH1HsX2KEHJiZgCvk2NY9aF0uxc3osrOp8BF5Gc00ogAw20
IqH+VUI0GSkAUSlWVo0NGrG6ZKG+RfIrEpt8DqVb8iQ8rEGuhzPZayfehuwzg/vN
x/swpp5J8H64a9Bp3dx0ANFlDRg+vX2Zwy0fvUmZHfnEa84QeQsZ6bkD3miHkaDy
bRIO2mbRoEwzBU0UBaev8ciIjlucL9nXPdxRnxbY8Z3wugsne1UvTvcglHPFi/GL
JH3as1ar9pBG3W1ZiUd9kywiQdfTXsKGyB3wnmCE3oA6zXCp4kzWvNu5isftrLUF
pLGjiVv2LJxN7T8H4hYp+6/hYlsoQbMqZWRGmTkyDaOn/71BYhcg5GGauEw7oKIt
LtJEm/8mor8VvG+jlMuDVUyXWOzgCJAu7op4Yb88SM66STo7vxfN+yuQ+3m0MLYq
PNj1yNAJrotloS37eNSh3FDUBZwSp5YI/JLP88lBI4+HUXUOOz8/TJV2HmQP5yOZ
koB8yZjn3U4sfJ5NPYNb
=oaDM
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
