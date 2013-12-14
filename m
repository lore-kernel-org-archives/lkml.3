Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3LNRaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:30:35 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35429 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:33 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 00/12] i8k patch series
Date: Sat, 14 Dec 2013 09:30:07 -0800
Message-Id: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up and simplify the driver, add support for additional temperature
sensors, fix a problem seen with multi-core CPU, and add support
for additional systems.

----------------------------------------------------------------
Guenter Roeck (14):
      i8k: Convert to use pr_ functions instead of printk
      i8k: Fix various checkpatch warnings and errors
      i8k: Convert to use to hwmon_device_register_with_groups hwmon API
      i8k: Support additional temperature sensors
      MAINTAINERS: Add myself as i8k maintainer
      i8k: Remove obsolete link to out-of-tree driver
      i8k: Drop driver version number and info message at startup
      i8k: Force SMM to run on CPU 0
      i8k: Add copyright
      i8k: Add support for Dell Studio laptops
      i8k: Add support for Dell XPS M140
      i8k: Use driver_data field of dmi_system_id to override fan multiplier
      i8k: Stop reading SMM BIOS version during driver probe
      i8k: Implement hwmon based fan speed control

 MAINTAINERS        |    2 +-
 drivers/char/i8k.c |  358 +++++++++++++++++++++++++++++-----------------------
 2 files changed, 201 insertions(+), 159 deletions(-)
