Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3AQJT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:19:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51315 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab3AQJTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:19:22 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2 0/2] LOW power sleep support for TI PWM submodules
Date: Thu, 17 Jan 2013 14:50:01 +0530
Message-ID: <1358414403-13431-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI PWM sub modules like ECAP & EHRPWM can enter in low power sleep
state during low power transitions of the platforms (like in AM33XX).
This patch series support low power sleep transition support. This
patch series depend on [1] and [2] and tested for low sleep support
on AM335x-evm for ECAP based PWM backlight.

1. ARM: OMAP2+: AM33XX: Add suspend-resume support
   http://www.mail-archive.com/linux-omap@vger.kernel.org/msg82635.html
2. HWMOD fixes for AM33xx PWM submodules and device tree nodes.
   https://lkml.org/lkml/2013/1/2/87

Philip Avinash (2):
  pwm: pwm-tiehrpwm: Low power sleep support
  pwm: pwm-tiecap: Low power sleep support

 drivers/pwm/pwm-tiecap.c   |   53 ++++++++++++++++++++++++++++
 drivers/pwm/pwm-tiehrpwm.c |   83 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 136 insertions(+)

-- 
1.7.9.5

