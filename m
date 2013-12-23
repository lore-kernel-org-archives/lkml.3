Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3LWQMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:12:55 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51989 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3LWQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:12:54 -0500
From: Laszlo Papp <lpapp@kde.org>
To: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH 0/3] Add GPIO support for the MAX6650/6651 ICs
Date: Mon, 23 Dec 2013 16:08:06 +0000
Message-Id: <1387814889-16670-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Important text here later. It is now just an attempt to get some feedback about
the design of the new features. This set has only been compilation tested, and
has many errors with checkpatch.pl, et al. Really, the point is only to get
feedback about the direction, as there has been a lot of paid work put into
this to work better with upstream after the previously rejected change simple
hwmon change.

Laszlo Papp (3):
  mfd: MAX6650/6651 support
  hwmon: (max6650) Convert to be a platform driver
  gpio: MAX6650/6651 support

 drivers/gpio/Kconfig                |  14 ++
 drivers/gpio/Makefile               |   2 +
 drivers/gpio/gpio-max6651.c         |  72 +++++++++
 drivers/gpio/gpio-max665x.c         | 301 ++++++++++++++++++++++++++++++++++++
 drivers/hwmon/Kconfig               |   2 +-
 drivers/hwmon/max6650.c             | 150 +++++++++---------
 drivers/mfd/Kconfig                 |  11 ++
 drivers/mfd/Makefile                |   1 +
 drivers/mfd/max6651.c               | 132 ++++++++++++++++
 include/linux/mfd/max6651-private.h |  63 ++++++++
 10 files changed, 675 insertions(+), 73 deletions(-)
 create mode 100644 drivers/gpio/gpio-max6651.c
 create mode 100644 drivers/gpio/gpio-max665x.c
 create mode 100644 drivers/mfd/max6651.c
 create mode 100644 include/linux/mfd/max6651-private.h

-- 
1.8.5.1

