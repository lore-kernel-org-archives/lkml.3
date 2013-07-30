Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3G3M2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:28:06 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41340 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3G3M2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:28:04 -0400
MIME-Version: 1.0
Date: Tue, 30 Jul 2013 13:28:02 +0100
Message-ID: <CAF2Aj3j2z=Pd-uW_VL6P=JMeEWnkf8aierMHb5Y6bv+y-GDiMw@mail.gmail.com>
Subject: [GIT PULL] mfd: Patches due for the v3.12 merge window
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7b9f21e6a4051bb470d62b0601501376f9fc7db7:

  Merge tag 'mfd-3.11-1' of
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next into
mfd-3.11-merge (2013-07-08 23:52:21 +0200)

are available in the git repository at:


  git://git.linaro.org/people/ljones/mfd.git for-mfd-next

for you to fetch changes up to 50ef27e35c4fd91d40174a8bfd8220881376733e:

  mfd: ucb1x00: Explicitely include linux/device.h (2013-07-24 13:28:29 +0100)

----------------------------------------------------------------
Alexander Shiyan (1):
      mfd: syscon: Remove "base" field from private driver data

Andrea Adami (2):
      mfd: mcp: Add missing linux/device.h header
      mfd: ucb1x00: Explicitely include linux/device.h

Ankur Raina (2):
      mfd: Fix for DA9055 driver initialization
      mfd: Update DA9055 i2c device id name

J Keerthy (1):
      mfd: Add TPS659038 documentation under Palmas

Mark Brown (4):
      mfd: sec: Add register cache for interrupt mask registers
      mfd: wm8997: Make Kconfig prompt for WM8997 more consistent
      mfd: wm8994: Remove unneeded check for JACKDET
      mfd: wm8994: Remove check for active audio in runtime suspend

Patil, Rachna (2):
      MFD: ti_tscadc: ADC Clock check not required
      MFD: ti_tscadc: Disable TSC config registers in adc mode

Peter Ujfalusi (3):
      mfd: twl6040: Remove support for legacy (pdata) mode
      mfd: twl6040: Cosmetic, parameter alignment change
      mfd: twl6040: Cleanup in early error handling in probe function

Yadwinder Singh Brar (2):
      mfd: s2mps11: Add device tree support
      mfd: s2mps11: Remove clocks from regulators list

 Documentation/devicetree/bindings/mfd/palmas.txt  |  2 ++
 Documentation/devicetree/bindings/mfd/s2mps11.txt | 89
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                               |  2 +-
 drivers/mfd/da9055-core.c                         |  5 ++++
 drivers/mfd/da9055-i2c.c                          |  2 +-
 drivers/mfd/sec-core.c                            | 34 +++++++++++++++++++++++
 drivers/mfd/syscon.c                              |  8 +++---
 drivers/mfd/ti_am335x_tscadc.c                    | 24 ++++++++---------
 drivers/mfd/twl6040.c                             | 90
+++++++++++++++++++------------------------------------------
 drivers/mfd/wm8994-core.c                         | 44
+-----------------------------
 include/linux/mfd/mcp.h                           |  2 ++
 include/linux/mfd/samsung/s2mps11.h               |  6 +----
 include/linux/mfd/ti_am335x_tscadc.h              |  1 -
 include/linux/mfd/twl6040.h                       |  1 +
 include/linux/mfd/ucb1x00.h                       |  1 +
 15 files changed, 182 insertions(+), 129 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
