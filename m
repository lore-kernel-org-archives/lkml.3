Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3HEAtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 20:49:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59385 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3HEAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 20:49:39 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-e4-51fef6a1181c
Message-id: <51FEF6A0.4050901@samsung.com>
Date: Mon, 05 Aug 2013 09:49:36 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [GIT PULL] extcon next for 3.12
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkRHfht3+BBncOS1gcvF9vcf3Lc1aL
	5sXr2SzONr1ht7i8aw6bxe3GFWwObB77565h9+jbsorR4/iN7UwenzfJBbBEcdmkpOZklqUW
	6dslcGX8bXvDXLBCvqL9Cn8D4z/xLkZODgkBE4nJ93ayQdhiEhfurQezhQSWMkrsO+8IU3O9
	ZzNjFyMXUHw6o8TxNcugnFeMEvd+bmQBqeIV0JKY9OsLUIKDg0VAVWL6jxiQMBtQeP+LG2BD
	RQXCJFZOvwJVLijxY/I9MFtEQEPi5dFbLCAzmQVOMUrcnv6KCSQhDJS4/H8XM4jNLKAjsb91
	GhuELS+xec1bZpAGCYFl7BI/LixhB0mwCAhIfJt8iAXkCAkBWYlNB5ghPpCUOLjiBssERpFZ
	SHbPQjJ2FpKxCxiZVzGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIExsvpf88m7GC8d8D6EGMy
	0MqJzFKiyfnAeMsriTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA2Owfty2m39l/h456Tav2YXzq4jNxGSpV67lT0IVpplZXdbzvuT2YM8Pgz/i/kJO
	84s8+BZUJptvzXG89MX6W9rkw1miKhF8auY32qI6boU9EancIbL0cFl/mdf3qw2vIzPmpOaW
	cDDPaRZYs/boEgefCzKTrB/uYjxbvfrVU97K4OCzk9XOvldiKc5INNRiLipOBABDQCb3rQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQd2F3/4FGky+J2Bx8H69xfUvz1kt
	mhevZ7M42/SG3eLyrjlsFrcbV7A5sHnsn7uG3aNvyypGj+M3tjN5fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8bftDXPBCvmK9iv8DYz/xLsYOTkkBEwkrvds
	ZoSwxSQu3FvP1sXIxSEkMJ1R4viaZYwQzitGiXs/N7KAVPEKaElM+vUFKMHBwSKgKjH9RwxI
	mA0ovP/FDTYQW1QgTGLl9CtQ5YISPybfA7NFBDQkXh69xQIyk1ngFKPE7emvmEASwkCJy/93
	MYPYzAI6Evtbp7FB2PISm9e8ZZ7AyDcLyaxZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0
	L10vOT93EyM4Hp9J7WBc2WBxiFGAg1GJh3dH/d9AIdbEsuLK3EOMEhzMSiK87P1AId6UxMqq
	1KL8+KLSnNTiQ4zJQJ9OZJYSTc4Hpoq8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5ak
	ZqemFqQWwWxh4uCUamBs+7Vm86eUyYkb+Qx99j3y+XtxMxP7ZLYzZ0us1uasvvH6p+GzM46b
	lX0au/mznH/Mqq19tn/ivhllN6Ur9dNbTzTckpXt0q07VTcvmmXG05rGludHhP8cnmmowZE5
	aWvzw+SWTcf9Khujoot/8pkqnS6ONTP9NLGuSe7g7K2HfO/unGpwxmyJEktxRqKhFnNRcSIA
	rXwAoQsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is extcon-next pull request for 3.12. I add detailed description
of this pull request on below. Please pull extcon with following updates.

Best Regards,
Chanwoo Choi

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.12

for you to fetch changes up to 1a82e81e0ede6955684397ffbc0964191ef13cba:

  extcon: adc-jack: Use power efficient workqueue (2013-08-05 08:53:34 +0900)

----------------------------------------------------------------
Update extcon for 3.12

This patchset add new file for OF helper API and modify small fix of extcon-palmas
driver. Also, extcon core dirver use power_efficient_wq instead of system_wq.

Detailed description for patchset:
1. Add new file for OF helper API
- Add OF(OpenFirmware) Helper API which is of_extcon_get_extcon_device().
  This helper API get the extcon device name on extcon consumer device.
- Add usage case about OF helper API of extcon in dwc3-omap.c. dwc3-omap driver
  use extcon subsystem to detect the state of USB/USB-Host cable so dwc3-omap
  call of_extcon_get_extcon_device() to need extcon device name.

2. Modify extcon-palmas.c driver
- Provide option to select whether interrupt is used or not
- Support suspend/resume for palmas driver
- Update palmas interrupt register to detect ID pin
- Code clean to remove unused data
- Rename filename for device tree binding (extcon-twl.txt -> extcon-palmas.txt)

3. Use power_effcient_wq on extcon core driver/extcon-arizona instead of system_wq
- extcon core driver(extcon-gpio.c/extcon-adc-jack.c) use power_effcient_wq
instead of system_wq.

----------------------------------------------------------------
Kishon Vijay Abraham I (3):
      extcon: Add an API to get extcon device from dt node
      usb: dwc3: use extcon fwrk to receive connect/disconnect
      extcon: palmas: remove assigning "edev.name" to palmas

Laxman Dewangan (6):
      extcon: palmas: rename device tree binding matching with file name
      extcon: palmas: devicetree: remove non-require property details
      extcon: palmas: remove unused member from palams_usb structure
      extcon: palmas: enable ID_GND and ID_FLOAT detection always
      extcon: palams: add support for suspend/resume
      extcon: palmas: Option to disable ID/VBUS detection based on platform

Mark Brown (3):
      extcon: arizona: Use power efficient workqueue
      extcon: gpio: Use power efficient workqueue for debounce
      extcon: adc-jack: Use power efficient workqueue

 .../extcon/{extcon-twl.txt => extcon-palmas.txt}   |   6 +-
 Documentation/devicetree/bindings/usb/omap-usb.txt |   5 +
 drivers/extcon/Kconfig                             |   4 +
 drivers/extcon/Makefile                            |   2 +
 drivers/extcon/extcon-adc-jack.c                   |   3 +-
 drivers/extcon/extcon-arizona.c                    |  25 ++--
 drivers/extcon/extcon-class.c                      |   3 +-
 drivers/extcon/extcon-gpio.c                       |   2 +-
 drivers/extcon/extcon-palmas.c                     | 134 ++++++++++++++-------
 drivers/extcon/of_extcon.c                         |  64 ++++++++++
 drivers/usb/dwc3/Kconfig                           |   1 +
 drivers/usb/dwc3/dwc3-omap.c                       | 125 ++++++++++++++++---
 include/linux/extcon/of_extcon.h                   |  31 +++++
 include/linux/mfd/palmas.h                         |   8 +-
 include/linux/usb/dwc3-omap.h                      |  30 -----
 15 files changed, 329 insertions(+), 114 deletions(-)
 rename Documentation/devicetree/bindings/extcon/{extcon-twl.txt => extcon-palmas.txt} (67%)
 create mode 100644 drivers/extcon/of_extcon.c
 create mode 100644 include/linux/extcon/of_extcon.h
 delete mode 100644 include/linux/usb/dwc3-omap.h
