Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaCJQcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:32:51 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.143]:35549 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502AbaCJQct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:32:49 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-13.tower-179.messagelabs.com!1394469134!31062966!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1394468644.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Mon, 10 Mar 2014 16:24:04 +0000
Subject: [PATCH V1 0/2]  da9063: Support for OnKey
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML-INPUT <linux-input@vger.kernel.org>,
        LKML-KERNEL <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

This patch series adds support for the DA9063 OnKey.

It has been split into two parts because the OnKey driver
requires a minor alteration to the da9063-core.c file and
the platform data header file. These parts have been
separated out.

- Add a new OnKey driver for DA9063;
- Minor addition "ONKEY" name to OnKey IRQ resource structure;

Thank you,
Steve Twiss, Dialog Semiconductor Ltd.

S Twiss (2):
  mfd: da9063: Linkages for ONKEY support in core files
  input: misc: da9063: OnKey driver

 drivers/input/misc/Kconfig        |  10 ++
 drivers/input/misc/Makefile       |   1 +
 drivers/input/misc/da9063-onkey.c | 209 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/da9063-core.c         |   1 +
 include/linux/mfd/da9063/pdata.h  |   1 +
 5 files changed, 222 insertions(+)
 create mode 100644 drivers/input/misc/da9063-onkey.c

-- 
end-of-patch for PATCH V1

