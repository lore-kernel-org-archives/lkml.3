Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab3CNKhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33267 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862Ab3CNKhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:09 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 0/3] Platform support for EHRPWM & ECAP devices in Davinci.
Date: Thu, 14 Mar 2013 16:07:30 +0530
Message-ID: <1363257453-24747-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform support for EHRPWM and ECAP by providing clock nodes and
device tree nodes.
This series depends on [1] and [2] and is available for testing at [3]

[1] http://gitorious.org/linux-davinci/linux-davinci/trees/davinci-for-v3.9/dt-2
[2] https://gitorious.org/linux-pwm/linux-pwm/trees/for-next
[3] https://github.com/avinashphilip/am335x_linux/tree/davinci-for-v3.9_soc_pwm

Philip Avinash (3):
  arm: davinci: clock node support for ECAP & EHRPWM
  ARM: davinci: da850: Enable EHRPWM TBCLK from CFG_CHIP1
  ARM: davinci: da850: add EHRPWM & ECAP DT node

 arch/arm/boot/dts/da850.dtsi               |   30 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/da850.c              |   24 ++++++++++++++++++++++
 arch/arm/mach-davinci/da8xx-dt.c           |   20 +++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 4 files changed, 75 insertions(+)

-- 
1.7.9.5

