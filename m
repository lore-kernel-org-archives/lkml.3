Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaFIGKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 02:10:16 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38975 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaFIGKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 02:10:13 -0400
Date: Sun, 8 Jun 2014 23:10:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.16-rc0
Message-ID: <20140609061009.GA29871@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a big update to
Atmel touchscreen driver, devm support for polled input devices, several
drivers have been converted to using managed resources, and assorted
driver fixes.

Changelog:
---------

Alexander Shiyan (3):
      Input: gpio-beeper - simplify GPIO handling
      Input: gpio_keys - more conversions to devm-* API
      Input: gpio_keys_polled - convert to devm-* API

Andy Shevchenko (2):
      Input: gpio_keys - convert to use devm_*
      Input: gpio_keys - convert struct descriptions to kernel-doc

Benjamin Tissoires (1):
      Input: synaptics - fix resolution for manually provided min/max

Benson Leung (2):
      Input: atmel_mxt_ts - wait for CHG assert in mxt_check_bootloader
      Input: atmel_mxt_ts - wait for CHG after bootloader resets

Beomho Seo (4):
      Input: mcs_touchkey - fix incorrect input device name
      Input: mms114 - fix incorrect input device name
      Input: mcs5000_ts - fix incorrect input device name
      Input: mcs5000_ts - switch to using managed resources

Christian Engelmayer (1):
      Input: ims-pcu - fix uninitialized use of 'error' in ims_pcu_buffers_=
alloc()

Daniel Kurtz (1):
      Input: atmel_mxt_ts - define helper functions for size and instances

Daniele Forsi (1):
      Input: logips2pp - fix typo in Kconfig help

Dmitry Torokhov (3):
      Input: evdev - get rid of old workaround for EVIOCGBIT
      Input: remove race when instantiating polled device attributes
      Input: implement managed polled input devices

Ezequiel Garcia (1):
      Input: gpio-keys - move the gpio-keys bindings documentation

Fabio Estevam (1):
      Input: twl6040-vibra - use devm functions

Gabriel FERNANDEZ (1):
      Input: add st-keyscan driver

Hans de Goede (4):
      Input: add driver for Allwinner sunxi SoC's rtp controller
      Input: sun4i-ts - add support for temperature sensor
      Input: elantech - deal with clickpads reporting right button events
      Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk =
is set

Himangi Saraogi (8):
      Input: da9034-ts - switch to using managed resources
      Input: adp5520-keys - switch to using managed resources
      Input: jornada680_kbd - switch top using managed resources
      Input: intel-mid-touch - switch to using managed resources
      Input: 88pm860x_onkey - switch to using managed resources
      Input: 88pm860x-ts - switch to using managed resources
      Input: max8925_onkey - switch to using managed resources
      Input: ab8500-ponkey - switch to using managed resources

Iiro Valkonen (1):
      Input: atmel_mxt_ts - make wait-after-reset period compatible with al=
l chips

Jason Gerecke (3):
      Input: wacom - add support for 0x116 sensor on Win8 Panasonic CF-H2
      Input: wacom - use unaligned access where necessary
      Input: wacom - add support for three new ISDv4 sensors

Jean Delvare (1):
      Input: w90p910_ts - depend on ARCH_W90X900

Jingoo Han (13):
      Input: clps711x-keypad - make of_device_id array const
      Input: gpio_keys - make of_device_id array const
      Input: gpio_keys_polled - make of_device_id array const
      Input: imx_keypad - make of_device_id array const
      Input: gpio-beeper - make of_device_id array const
      Input: rotary_encoder - make of_device_id array const
      Input: olpc_apsp - make of_device_id array const
      Input: apbps2 - make of_device_id array const
      Input: auo-pixcir-ts - make of_device_id array const
      Input: egalax_ts - make of_device_id array const
      Input: lpc32xx_ts - make of_device_id array const
      Input: mms114 - make of_device_id array const
      Input: zforce - make of_device_id array const

Joachim Eastwood (2):
      ARM: OMAP2+: remove unused omap4-keypad file and code
      Input: omap-keypad - remove platform data support

Linus Walleij (1):
      Input: tc3589x-keypad - support probing from device tree

Mark Brown (2):
      Input: ads7846 - correct log message for spi_sync() errors
      Input: ads7877 - remove bitrotted comment

Nick Dyer (16):
      Input: atmel_mxt_ts - remove unnecessary platform data
      Input: atmel_mxt_ts - improve T19 GPIO keys handling
      Input: atmel_mxt_ts - return IRQ_NONE when interrupt handler fails
      Input: atmel_mxt_ts - select FW_LOADER for firmware code
      Input: atmel_mxt_ts - improve error reporting and debug
      Input: atmel_mxt_ts - implement CRC check for configuration data
      Input: atmel_mxt_ts - add additional bootloader addresses
      Input: atmel_mxt_ts - read and report bootloader version
      Input: atmel_mxt_ts - implement bootloader frame retries
      Input: atmel_mxt_ts - improve bootloader progress output
      Input: atmel_mxt_ts - add check for incorrect firmware file format
      Input: atmel_mxt_ts - read screen config from chip
      Input: atmel_mxt_ts - rename pressure to amplitude to match spec
      Input: atmel_mxt_ts - rename touchscreen defines to include T9
      Input: atmel_mxt_ts - handle multiple input reports in one message
      Input: atmel_mxt_ts - fix invalid return from mxt_get_bootloader_vers=
ion

Ping Cheng (2):
      Input: wacom - set stylus_in_proximity when pen is in range
      Input: wacom - process outbound for newer Cintiqs

Robert Woerle (1):
      Input: edt-ft5x06 - fix an i2c write for M09 support

Roger Quadros (4):
      Input: pixcir_i2c_ts - use devres managed resource allocations
      Input: pixcir_i2c_ts - initialize interrupt mode and power mode
      Input: pixcir_i2c_ts - get rid of pdata->attb_read_val()
      Input: pixcir_i2c_ts - implement wakeup from suspend

Sachin Kamat (2):
      Input: soc_button_array - remove duplicate inclusion of input.h
      Input: max8997_haptic - add error handling for regulator and pwm

Sebastian Reichel (5):
      Input: tsc2005 - use dev_err for error messages
      Input: tsc2005 - convert driver to use devm_*
      Input: add common DT binding for touchscreens
      Input: tsc2005 - add DT support
      DTS: ARM: OMAP3-N900: Add tsc2005 support

Stephen Boyd (1):
      Input: pmic8xxx-pwrkey - set sane default for debounce time


Diffstat:
--------

 .../{gpio/gpio_keys.txt =3D> input/gpio-keys.txt}    |   0
 .../devicetree/bindings/input/st-keyscan.txt       |  60 ++
 .../bindings/input/touchscreen/sun4i.txt           |  20 +
 .../bindings/input/touchscreen/touchscreen.txt     |  27 +
 .../bindings/input/touchscreen/tsc2005.txt         |  42 +
 arch/arm/boot/dts/omap3-n900.dts                   |  17 +-
 arch/arm/mach-omap2/devices.c                      |  33 -
 arch/arm/mach-omap2/omap4-keypad.h                 |   8 -
 arch/arm/mach-s5pv210/mach-goni.c                  |   8 -
 drivers/input/evdev.c                              |  18 -
 drivers/input/input-polldev.c                      | 131 +++-
 drivers/input/keyboard/Kconfig                     |  13 +-
 drivers/input/keyboard/Makefile                    |   1 +
 drivers/input/keyboard/adp5520-keys.c              |  32 +-
 drivers/input/keyboard/clps711x-keypad.c           |   2 +-
 drivers/input/keyboard/gpio_keys.c                 | 145 ++--
 drivers/input/keyboard/gpio_keys_polled.c          | 100 +--
 drivers/input/keyboard/imx_keypad.c                |   2 +-
 drivers/input/keyboard/jornada680_kbd.c            |  36 +-
 drivers/input/keyboard/mcs_touchkey.c              |   2 +-
 drivers/input/keyboard/omap4-keypad.c              |  32 +-
 drivers/input/keyboard/st-keyscan.c                | 274 +++++++
 drivers/input/keyboard/tc3589x-keypad.c            |  66 +-
 drivers/input/misc/88pm860x_onkey.c                |  40 +-
 drivers/input/misc/Kconfig                         |   2 +-
 drivers/input/misc/ab8500-ponkey.c                 |  54 +-
 drivers/input/misc/gpio-beeper.c                   |  29 +-
 drivers/input/misc/ims-pcu.c                       |   1 +
 drivers/input/misc/max8925_onkey.c                 |  55 +-
 drivers/input/misc/max8997_haptic.c                |  18 +-
 drivers/input/misc/pmic8xxx-pwrkey.c               |   8 +-
 drivers/input/misc/rotary_encoder.c                |   2 +-
 drivers/input/misc/soc_button_array.c              |   1 -
 drivers/input/misc/twl6040-vibra.c                 |  83 +-
 drivers/input/mouse/Kconfig                        |   2 +-
 drivers/input/mouse/elantech.c                     |  27 +-
 drivers/input/mouse/synaptics.c                    |  19 +-
 drivers/input/serio/apbps2.c                       |   2 +-
 drivers/input/serio/olpc_apsp.c                    |   2 +-
 drivers/input/tablet/wacom_sys.c                   |  19 +
 drivers/input/tablet/wacom_wac.c                   |  92 ++-
 drivers/input/tablet/wacom_wac.h                   |   6 +
 drivers/input/touchscreen/88pm860x-ts.c            |  41 +-
 drivers/input/touchscreen/Kconfig                  |  18 +-
 drivers/input/touchscreen/Makefile                 |   2 +
 drivers/input/touchscreen/ad7877.c                 |   5 -
 drivers/input/touchscreen/ads7846.c                |   2 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           | 862 ++++++++++++++---=
----
 drivers/input/touchscreen/auo-pixcir-ts.c          |   2 +-
 drivers/input/touchscreen/da9034-ts.c              |  39 +-
 drivers/input/touchscreen/edt-ft5x06.c             |   2 +-
 drivers/input/touchscreen/egalax_ts.c              |   2 +-
 drivers/input/touchscreen/intel-mid-touch.c        |  47 +-
 drivers/input/touchscreen/lpc32xx_ts.c             |   2 +-
 drivers/input/touchscreen/mcs5000_ts.c             |  83 +-
 drivers/input/touchscreen/mms114.c                 |   4 +-
 drivers/input/touchscreen/of_touchscreen.c         |  45 ++
 drivers/input/touchscreen/pixcir_i2c_ts.c          | 281 ++++++-
 drivers/input/touchscreen/sun4i-ts.c               | 339 ++++++++
 drivers/input/touchscreen/tsc2005.c                | 157 +++-
 drivers/input/touchscreen/zforce_ts.c              |   2 +-
 drivers/platform/chrome/chromeos_laptop.c          |  33 +-
 include/linux/gpio_keys.h                          |  48 +-
 include/linux/i2c/atmel_mxt_ts.h                   |  27 +-
 include/linux/input-polldev.h                      |   3 +
 include/linux/input/pixcir_ts.h                    |  44 +-
 include/linux/input/touchscreen.h                  |  22 +
 include/linux/platform_data/omap4-keypad.h         |  13 -
 68 files changed, 2517 insertions(+), 1139 deletions(-)
 rename Documentation/devicetree/bindings/{gpio/gpio_keys.txt =3D> input/gp=
io-keys.txt} (100%)
 create mode 100644 Documentation/devicetree/bindings/input/st-keyscan.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/sun=
4i.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/tou=
chscreen.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/tsc=
2005.txt
 delete mode 100644 arch/arm/mach-omap2/omap4-keypad.h
 create mode 100644 drivers/input/keyboard/st-keyscan.c
 create mode 100644 drivers/input/touchscreen/of_touchscreen.c
 create mode 100644 drivers/input/touchscreen/sun4i-ts.c
 create mode 100644 include/linux/input/touchscreen.h
 delete mode 100644 include/linux/platform_data/omap4-keypad.h

--=20
Dmitry


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTlU/BAAoJEH70+W8r6ZYqSt4P/R4QfWPbvzdugdSnhoCcFZgT
u563JDDEPvmG1X9E6QL3Ov2vTnURhSoo30R5Jx9Mdi8tR/p4TQ4AXcvTvJGlpReK
+2wZeJwcLzqvxlOliLaNebYPzNhAFcLZqNMayiHgr/pUcJNfFzxnuJ1n15e+vheC
FZGqJ1L/2oyMk7Q7kBybZREke36zDDIMIfEZf8m9/ek/Tdbey26qBdbM7vFVdQKR
738zF/5Bf6VQNq2JfgECt8msbHk/oADKCOOY4gT54RfSbXsWD9EaE4UF+N+RI1iW
TrHeg4+8y9Fq+e6ursGftTa4reMbV5xU+v4SmGeqD3l80W8rrdu4949Yj71eozOv
TR8s1gqaAh/dlT7yo6GMIRdTG0ZRVdHSZBJYOwNoyOXFX6/N7IFL8sJ8QherVXDx
skHy4O6EyUMn+9oGpwBGqGh4zvYa9eB9bEQcUIXZpNYTD+asvvletuMkrb0EDLzT
ycfWORxXINhtmPaDcRnPhXffff60jqW3EOyZXb3yBHLWRCYvPF3NOdxWfPTIlur3
6RqHqKO/tTkU3A0o6YEQ8znSsu2xP9cySB9qJDeWyOrSH9F5Y3bBZv/RjtCU3EaB
oQATIFFLL0nCqtgMjy3q/EjzasTQUkXHgRLTaPg8h/Va/RNFHh7480sMGpUKXr4Y
oC/okoRuWa/ZYDBWKPqV
=0e0f
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
