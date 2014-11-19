Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbaKSReK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:34:10 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35514 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbaKSReI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:34:08 -0500
Date: Wed, 19 Nov 2014 17:34:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: wsa@the-dreams.de, julia.lawall@lip6.fr, dan.carpenter@oracle.com,
        johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Immutable branch between MFD, GPIO and I2C (Second batch) 
Message-ID: <20141119173401.GL1875@x1>
References: <1416315480-2053-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416315480-2053-1-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Wolfram,

Second instalment.  Enjoy!

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-gpio-i2c-v3.19-1

for you to fetch changes up to 2fc2b4846c14c8c2d2c6e9114b4548f846521cfb:

  mfd: dln2: A couple endian fixes (2014-11-19 17:12:59 +0000)

----------------------------------------------------------------
Immutable branch between MFD, GPIO and I2C due for v3.19.

This is the second such tag, due to more patches (fixes) added.

----------------------------------------------------------------
Dan Carpenter (1):
      mfd: dln2: A couple endian fixes

Daniel Baluta (1):
      gpio: add support for the Diolan DLN-2 USB GPIO driver

Johan Hovold (1):
      mfd: core: Add helper function to register hotplug devices

Laurentiu Palcu (1):
      i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (4):
      mfd: Add support for Diolan DLN-2 devices
      mfd: dln2: Fix _dln2_transfer return code
      i2c: dln2: Simplify return flow for dln2_i2c_enable
      mfd: dln2: Add a limit check for invalid echo

 drivers/gpio/Kconfig          |  12 +
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-dln2.c      | 553 ++++++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 262 ++++++++++++++
 drivers/mfd/Kconfig           |  10 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 769 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/core.h      |   7 +
 include/linux/mfd/dln2.h      | 103 ++++++
 11 files changed, 1729 insertions(+)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
