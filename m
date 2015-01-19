Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbbASQhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:37:48 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:10563 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbbASQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:37:45 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-8.tower-38.messagelabs.com!1421685461!8060873!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1421684991.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Mon, 19 Jan 2015 16:29:51 +0000
Subject: [PATCH V2 0/2]  Add device tree support for DA9063 
To: David Dajun Chen <david.chen@diasemi.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        "Mark Brown" <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "Support Opensource" <support.opensource@diasemi.com>
CC: DT <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

This patch set adds device tree support for the Dialog
Semiconductor DA9063 PMIC. Support is provided for the
Regulators; Real-Time Clock and Watchdog.

[PATCH V2 1/2]: kernel driver device tree support
[PATCH V2 2/2]: device tree bindings document

Thank you,
Steve Twiss, Dialog Semiconductor Ltd.

S Twiss (2):
  mfd: da9063: Add device tree support
  devicetree: Add bindings for DA9063

 Documentation/devicetree/bindings/mfd/da9063.txt | 94 ++++++++++++++++++++++++
 drivers/mfd/da9063-core.c                        |  2 +
 drivers/mfd/da9063-i2c.c                         | 11 +++
 include/linux/mfd/da9063/core.h                  |  1 +
 4 files changed, 108 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9063.txt

-- 
end-of-patch for PATCH V2

