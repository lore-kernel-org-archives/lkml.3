Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3KURsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:48:02 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54678 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KURsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:48:00 -0500
Date: Thu, 21 Nov 2013 09:47:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.13-rc1 [#2]
Message-ID: <20131121174758.GA12141@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon updates for Linux 3.13-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 2d3c627502f2a9b0a7de06a5a2df2365542a72c9:

  Revert "init/Kconfig: add option to disable kernel compression" (2013-11-17 11:17:36 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 3a4cbc190643d0c6f7ca36a84af8367947f558c7:

  hwmon: (acpi_power_meter) Fix acpi_bus_get_device() return value check (2013-11-20 08:31:01 -0800)

----------------------------------------------------------------
hwmon updates for 3.13-rc1 [#2]

acpi_power_meter: Fix return value check from call to acpi_bus_get_device
nct6775: Fix/improve NCT6791 support
lm75: Add support for GMT G751

----------------------------------------------------------------
Arnaud Ebalard (1):
      hwmon: (lm75) Add support for GMT G751 chip

Guenter Roeck (2):
      hwmon: (nct6775) Monitor additional temperature registers
      hwmon: (nct6775) NCT6791 supports weight control only for CPUFAN

Yijing Wang (1):
      hwmon: (acpi_power_meter) Fix acpi_bus_get_device() return value check

 .../devicetree/bindings/i2c/trivial-devices.txt    |    1 +
 drivers/hwmon/Kconfig                              |    1 +
 drivers/hwmon/acpi_power_meter.c                   |    5 +-
 drivers/hwmon/lm75.c                               |    3 +
 drivers/hwmon/nct6775.c                            |   91 +++++++++++++++++---
 5 files changed, 88 insertions(+), 13 deletions(-)
