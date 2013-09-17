Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3IQGZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 02:25:15 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14786 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3IQGZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 02:25:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 16 Sep 2013 23:21:47 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <broonie@kernel.org>,
        <linus.walleij@linaro.org>, <akpm@linux-foundation.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <grant.likely@linaro.org>, <florian.lobmaier@ams.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] Add AMS AS3722 mfd, GPIO, regulator and RTC driver
Date: Tue, 17 Sep 2013 12:15:34 +0530
Message-ID: <1379400338-20704-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the driver support for AMS AS3722 PMIC. The driver
includes mfd, gpio, regulator and  rtc.

Laxman Dewangan (4):
  mfd: add support for AMS AS3722 PMIC
  gpio: add support for AMS AS3722 gpio driver
  regulator: as3722: add regulator driver for AMS AS3722
  drivers/rtc/rtc-as3722: add RTC driver

 .../devicetree/bindings/gpio/gpio-as3722.txt       |   63 ++
 Documentation/devicetree/bindings/mfd/as3722.txt   |   69 ++
 .../bindings/regulator/as3722-reguator.txt         |  103 +++
 .../devicetree/bindings/rtc/rtc-as3722.txt         |   21 +
 drivers/gpio/Kconfig                               |    6 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-as3722.c                         |  444 ++++++++++
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/as3722.c                               |  463 ++++++++++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/as3722-regulator.c               |  883 ++++++++++++++++++++
 drivers/rtc/Kconfig                                |   10 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-as3722.c                           |  315 +++++++
 include/linux/mfd/as3722.h                         |  425 ++++++++++
 17 files changed, 2826 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-as3722.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/as3722.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/as3722-reguator.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/rtc-as3722.txt
 create mode 100644 drivers/gpio/gpio-as3722.c
 create mode 100644 drivers/mfd/as3722.c
 create mode 100644 drivers/regulator/as3722-regulator.c
 create mode 100644 drivers/rtc/rtc-as3722.c
 create mode 100644 include/linux/mfd/as3722.h

