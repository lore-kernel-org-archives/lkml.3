Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaCEMdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:33:44 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.177]:49030 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbaCEMdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:33:42 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-7.tower-38.messagelabs.com!1394022819!17509309!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1394022316.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Wed, 5 Mar 2014 12:25:16 +0000
Subject: [RFC V1 0/2]  da9063: Support for RTC and register definition updates
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
end-of-patch for RFC V1

