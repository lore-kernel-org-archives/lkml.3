Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaCFQvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:51:47 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.120]:23383 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbaCFQvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:51:46 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-6.tower-194.messagelabs.com!1394124683!14243060!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1394124002.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Thu, 6 Mar 2014 16:40:02 +0000
Subject: [PATCH V1 0/2]  da9063: Support for RTC and register definition updates
To: Alessandro Zummo <a.zummo@towertech.it>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

This patch series updates the register definitions for the DA9063 PMIC
and adds support for the DA9063 RTC.

- Changes to the DA9063 registers.h to support production silicon;
- Add a new RTC driver which is applicable to this version of the silicon;

Thank you,
Steve Twiss, Dialog Semiconductor Ltd.

S Twiss (2):
  mfd: da9063: Upgrade of register definitions to support production
    silicon
  rtc: da9063: RTC driver

 drivers/rtc/Kconfig                  |   10 +
 drivers/rtc/Makefile                 |    1 +
 drivers/rtc/rtc-da9063.c             |  332 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9063/registers.h |  120 ++++++------
 4 files changed, 405 insertions(+), 58 deletions(-)
 create mode 100644 drivers/rtc/rtc-da9063.c

-- 
end-of-patch for PATCH V1

