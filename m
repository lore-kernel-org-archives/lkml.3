Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaHTLUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:20:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:9046 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaHTLUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:20:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="374704749"
From: Daniel Baluta <daniel.baluta@intel.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, wsa@the-dreams.de,
        linux-i2c@vger.kernel.org, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org
Cc: pratyush.anand@st.com, pebolle@tiscali.nl, stern@rowland.harvard.edu,
        octavian.purdila@intel.com, matthew@mjdsystems.ca,
        linux-kernel@vger.kernel.org, laurentiu.palcu@intel.com,
        daniel.baluta@intel.com, jdelvare@suse.de, arnd@arndb.de,
        sjg@chromium.org
Subject: [PATCH 0/3] dln-2: Add support for Diolan DLN-2 devices
Date: Wed, 20 Aug 2014 14:24:44 +0300
Message-Id: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter DLN-2.
Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

There is no support for SPI part yet.

Daniel Baluta (1):
  gpio: add support for the Diolan DLN-2 USB-GPIO driver

Laurentiu Palcu (1):
  i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (1):
  usb: add support for Diolan DLN-2 devices

 drivers/gpio/Kconfig          |  13 +
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-dln2.c      | 571 +++++++++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig    |  11 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 328 +++++++++++++++++++
 drivers/usb/misc/Kconfig      |   6 +
 drivers/usb/misc/Makefile     |   1 +
 drivers/usb/misc/dln2.c       | 719 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/dln2.h      | 146 +++++++++
 10 files changed, 1797 insertions(+)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/usb/misc/dln2.c
 create mode 100644 include/linux/usb/dln2.h

-- 
1.9.1

