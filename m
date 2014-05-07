Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbaEGNE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:04:57 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.108]:16805 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932853AbaEGNEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:04:55 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-2.tower-193.messagelabs.com!1399467889!2067648!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1399465372.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Wed, 7 May 2014 13:22:52 +0100
Subject: [RESEND] [PATCH V1 0/2]  da9063: Support for RTC and register definition updates
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@linaro.org>,
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

- PATCH-0001 Changes to the DA9063 registers.h to support production silicon;
- PATCH-0002 Add a new RTC driver which is applicable to this version of the silicon;

This is a resend of the original patch set, now adding Andrew Morton after
the RTC driver PATCH-0002 has been waiting to be merged since March.

Would it be possible to merge PATCH-0002 into linux-next please?

This patch has already been Acked by Alessandro Zummo but has not been able
to be applied: https://lkml.org/lkml/2014/3/26/56

- PATCH-0001 Please note that Lee Jones has already applied the registers.h
  patch into the linux-next tree. See here: https://lkml.org/lkml/2014/3/10/267

- PATCH-0002 The RTC component of the patch set was originally Acked here:
  https://lkml.org/lkml/2014/3/7/112 but has not yet been merged.

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

