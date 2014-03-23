Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaCWVDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 17:03:46 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.138]:29466 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979AbaCWVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 17:03:41 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-9.tower-179.messagelabs.com!1395608616!26673463!4
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1395607051.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Sun, 23 Mar 2014 20:37:31 +0000
Subject: [RFC V1 0/3]  da9063: Addition of HWMON support for DA9063
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        Lee Jones <lee.jones@linaro.org>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LINUX-DOC <linux-doc@vger.kernel.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        LM-SENSORS <lm-sensors@lm-sensors.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

This patch series covers hardware monitoring support for the DA9063 PMIC.

There are three patches in this set:
 - Add a new HWMON driver component
 - Minor MFD core and platform data changes for HWMON
 - Documentation

Thank you,
Steve Twiss, Dialog Semiconductor Ltd.

S Twiss (3):
  hwmon: da9063: HWMON driver
  mfd: da9063: Add HWMON dependencies
  Documentation: hwmon: New information for DA9063

 Documentation/hwmon/da9063           |   67 +++++
 drivers/hwmon/Kconfig                |   10 +
 drivers/hwmon/Makefile               |    1 +
 drivers/hwmon/da9063-hwmon.c         |  456 ++++++++++++++++++++++++++++++++++
 drivers/mfd/da9063-core.c            |   13 +-
 include/linux/mfd/da9063/core.h      |    3 +
 include/linux/mfd/da9063/pdata.h     |   18 ++
 include/linux/mfd/da9063/registers.h |   34 +++
 8 files changed, 601 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/hwmon/da9063
 create mode 100644 drivers/hwmon/da9063-hwmon.c

-- 
end-of-patch for RFC V1

