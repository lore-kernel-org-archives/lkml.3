Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab3FXEHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 00:07:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:5919 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab3FXEHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 00:07:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,925,1363158000"; 
   d="scan'208";a="334396269"
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: [PATCH v3 0/4] Kontron PLD drivers
Date: Sun, 23 Jun 2013 21:00:02 -0700
Message-Id: <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
-Change Michael's "Signed-off-by" to "Originally-From" in all patches
-Add "From: Guenter Roeck <linux@roeck-us.net>" to gpio patch

Guenter Roeck (1):
  gpio: Kontron PLD gpio driver

Kevin Strasser (3):
  mfd: Kontron PLD mfd driver
  i2c: Kontron PLD i2c bus driver
  watchdog: Kontron PLD watchdog timer driver

 drivers/gpio/Kconfig            |   12 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/gpio-kempld.c      |  225 ++++++++++++++
 drivers/i2c/busses/Kconfig      |   10 +
 drivers/i2c/busses/Makefile     |    1 +
 drivers/i2c/busses/i2c-kempld.c |  410 +++++++++++++++++++++++++
 drivers/mfd/Kconfig             |   21 ++
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/kempld-core.c       |  642 +++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/Kconfig        |   11 +
 drivers/watchdog/Makefile       |    1 +
 drivers/watchdog/kempld_wdt.c   |  580 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/kempld.h      |  125 ++++++++
 13 files changed, 2040 insertions(+)
 create mode 100644 drivers/gpio/gpio-kempld.c
 create mode 100644 drivers/i2c/busses/i2c-kempld.c
 create mode 100644 drivers/mfd/kempld-core.c
 create mode 100644 drivers/watchdog/kempld_wdt.c
 create mode 100644 include/linux/mfd/kempld.h

-- 
1.7.9.5

