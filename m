Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaBNJQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:16:15 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62903 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaBNJQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:16:03 -0500
From: Laszlo Papp <lpapp@kde.org>
To: jdelvare@suse.de, linux@roeck-us.net
Cc: lm-sensors@lm-sensors.org, lee.jones@linaro.org, lpapp@kde.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] Redesign the MAX6650-6651 driver to be more flexible
Date: Fri, 14 Feb 2014 09:15:40 +0000
Message-Id: <1392369342-11472-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yet to be run-time tested, but early reviews are welcome to catch any obvious
mistakes that are potentially hard and time-consuming to debug.

Laszlo Papp (2):
  mfd: MAX6650/6651 support
  hwmon: (max6650) Convert to be a platform driver

 drivers/hwmon/Kconfig               |   2 +-
 drivers/hwmon/max6650.c             | 125 ++++++++++++++++++------------------
 drivers/mfd/Kconfig                 |  11 ++++
 drivers/mfd/Makefile                |   1 +
 drivers/mfd/max665x.c               |  94 +++++++++++++++++++++++++++
 include/linux/mfd/max665x-private.h |  34 ++++++++++
 6 files changed, 203 insertions(+), 64 deletions(-)
 create mode 100644 drivers/mfd/max665x.c
 create mode 100644 include/linux/mfd/max665x-private.h

-- 
1.8.5.4

