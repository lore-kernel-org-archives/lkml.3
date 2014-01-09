Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaAICC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 21:02:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21450 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAICCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 21:02:23 -0500
X-AuditID: cbfee68e-b7f566d000002344-78-52ce032db095
Message-id: <52CE0330.4090501@samsung.com>
Date: Thu, 09 Jan 2014 11:02:24 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon next for 3.14
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWyRsSkUFeP+VyQwdozTBbXvzxntWhevJ7N
	4mzTG3aLTY+vsVpc3jWHzeJ24wo2BzaP/XPXsHtsXlLv0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBk3Z15mKbgpW9H+6C9bA+M/sS5GTg4JAROJXUc2sUHYYhIX7q0Hsrk4hASWMkp8mbON
	Dabo65+1UIlFjBLTNzezQDivGCUOz9nB2sXIwcEroCVx9pAAiMkioCox4VwlSC8bUHT/ixtg
	c0QFwiRWTr/CAmLzCghK/Jh8D8wWEdCQeHn0FthIZoEXjBI/ZiwHaxAGSnQuuMIMYjML6Ejs
	b53GBmHLS2xe85YZpEFCYBm7xM3n/8GKWAQEJL5NPsQCcoSEgKzEpgPMEA9IShxccYNlAqPI
	LCS7ZyEZOwvJ2AWMzKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAiPm9L9nfTsYbx6wPsSY
	DLRyIrOUaHI+MOLySuINjc2MLExNTI2NzC3NSBNWEudd9DApSEggPbEkNTs1tSC1KL6oNCe1
	+BAjEwenVAPj5PvRNeapR5b1z9g3sUlx9tQ/PByLWo+IrwuSeXkuViv6+vsOhuatNZlr87Mb
	GE/POfhfZlJJpYL0AxfnmDk1/RN8TV/vrSzTXlVfLLLqm6bObHNr0xnqrHp537SCG5b9ELjw
	/Rjvs+JSOakFMy4u3jAzQTRgwZIc/arAk7z2OcdeXE3n0XJXYinOSDTUYi4qTgQABrsS9q4C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAV1d5nNBBnuemltc//Kc1aJ58Xo2
	i7NNb9gtNj2+xmpxedccNovbjSvYHNg89s9dw+6xeUm9R9+WVYwenzfJBbBENTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm3Jx5maXgpmxF+6O/bA2M/8S6GDk5JARMJL7+
	WcsGYYtJXLi3Hsjm4hASWMQoMX1zMwuE84pR4vCcHaxdjBwcvAJaEmcPCYCYLAKqEhPOVYL0
	sgFF97+4ATZHVCBMYuX0KywgNq+AoMSPyffAbBEBDYmXR2+BjWQWeMEo8WPGcrAGYaBE54Ir
	zCA2s4COxP7WaWwQtrzE5jVvmScw8s1CMmsWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7N
	S9dLzs/dxAiOx2fSOxhXNVgcYhTgYFTi4V1RfDZIiDWxrLgy9xCjBAezkghvEcO5ICHelMTK
	qtSi/Pii0pzU4kOMyUCfTmSWEk3OB6aKvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeW
	pGanphakFsFsYeLglGpgdGtcsvRk0Q1Hw1W2qxJSo7nnth0Jv8J989uNTK4gDkum96nH1ft8
	Z6w88XWaye3XC6eH5W68/f9BhtVVvYQjyjL7BVkV9D3mFvN0vrrEtXKta6bD4/OiMdvfCgV8
	cVW66rn9npWC3WGlCX1CJz+of32boG+3qi7C//bbvU+Pm0Ws+be3YhfjGSWW4oxEQy3mouJE
	ADcU1BALAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

This is extcon-next full request for v3.14. I add detailed description of this
pull request on below. Please pull extcon with following updates.

This patchset is rebased on 'Linux 3-13-rc4' because char-misc-next is based on
'Linux 3-13-rc4'.

Best Regards,
Chanwoo Choi

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.14

for you to fetch changes up to 6544dfa5795060b01042fd62fd1a92e18c2fc485:

  extcon: gpio: Add power resume support (2014-01-09 09:53:30 +0900)

----------------------------------------------------------------
Update extcon for v3.14

This patchset add new driver of extcon-max14577.c which detect various external
connector and fix minor issue of extcon provider driver(extcon-arizona/palams/
gpio.c). Also, update documentation of previous 'switch' porting guide and
extcon git repository url.

Detailed description for patchset:
- New driver of extcon-max14577.c
: Add extcon-max14577.c drvier to support Maxim MUIC(Micro USB Interface
Controller) which detect USB/TA/JIG/AUDIO-DOCK and additional accessory
according to each resistance when connected external connector.

- extcon-arizoan.c driver
: Code clean to use define macro instead of hex value
: Fix minor issue to reset back to our staring state
: Fix race with microphone detection and removal

- extcon-palmas.c driver
: Fix minor issue and renaming compatible string of Devicetree

- extcon-gpio.c driver
: Fix bug about ordering initialization of gpio pin on probe()
: Send uevent after wakeup from suspend state because some SoC
  haven't wakeup interrupt on suspend state.

- Documentation (Documentation/extcon/porting-android-switch-class)
: Fix switch class porting guide

- Update extcon git repository url

----------------------------------------------------------------
Chanwoo Choi (2):
      MAINTAINERS: Add git repository for extcon
      extcon: max14577: Add extcon-max14577 driver to support MUIC device

Charles Keepax (5):
      extcon: arizona: Add defines for microphone detection levels
      extcon: arizona: Fix reset of HPDET after race with removal
      extcon: arizona: Fix race with microphone detection and removal
      extcon: arizona: No need to switch back down HPDET ranges
      extcon: arizona: Add support for headphone detection on wm5110 rev D

George Cherian (1):
      extcon: palmas: Handle ID interrupt properly using USB_ID_INT_SRC

Guenter Roeck (1):
      extcon: gpio: Request gpio pin before modifying its state

Kishon Vijay Abraham I (1):
      extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*

MyungJoo Ham (1):
      extcon: fix switch class porting guide (Documentation)

Rongjun Ying (1):
      extcon: gpio: Add power resume support

 .../devicetree/bindings/extcon/extcon-palmas.txt   |   6 +-
 Documentation/extcon/porting-android-switch-class  |   9 +-
 MAINTAINERS                                        |   1 +
 drivers/extcon/Kconfig                             |  10 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-arizona.c                    |  73 +-
 drivers/extcon/extcon-gpio.c                       |  32 +-
 drivers/extcon/extcon-max14577.c                   | 752 +++++++++++++++++++++
 drivers/extcon/extcon-palmas.c                     |  17 +-
 include/linux/extcon/extcon-gpio.h                 |   1 +
 include/linux/mfd/arizona/registers.h              |   9 +
 11 files changed, 876 insertions(+), 35 deletions(-)
 create mode 100644 drivers/extcon/extcon-max14577.c
