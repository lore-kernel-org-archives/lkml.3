Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3CNKcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:32:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51920 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab3CNKcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:32:14 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 0/3] Davinci support for EHRPWM & ECAP
Date: Thu, 14 Mar 2013 16:02:35 +0530
Message-ID: <1363257158-11615-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables EHRPWM & ECAP driver support for da850
platforms.

This patch series based on [1] and is available at [2]. This has been tested
backlight support using EHRPWM in da850-evm.

[1] https://gitorious.org/linux-pwm/linux-pwm/trees/for-next
[2] https://github.com/avinashphilip/am335x_linux/tree/davinci-for-v3.9_soc_pwm

Philip Avinash (3):
  pwm: davinci: Add Kconfig support for ECAP & EHRPWM devices
  pwm: pwm-tiecap: Add device-tree binding support for da850 SOC
  pwm: pwm-tiehrpwm: Add device tree binding support for da850 SOC

 .../devicetree/bindings/pwm/pwm-tiecap.txt         |    2 +-
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |    2 +-
 drivers/pwm/Kconfig                                |    8 +++-----
 drivers/pwm/pwm-tiecap.c                           |    1 +
 drivers/pwm/pwm-tiehrpwm.c                         |    1 +
 drivers/pwm/pwm-tipwmss.h                          |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.7.9.5

