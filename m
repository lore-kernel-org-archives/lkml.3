Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3CTGlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:41:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47509 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3CTGlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:41:18 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2 0/3] Platform support for EHRPWM & ECAP devices in DAVINCI.
Date: Wed, 20 Mar 2013 12:11:51 +0530
Message-ID: <1363761714-15034-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform support for EHRPWM and ECAP by providing clock nodes and
device tree nodes.
This series depends on [1] and [2] and is available for testing at [3].
Tested for backlight support in da850 EVM with EHRPWM PWM device.

[1] http://gitorious.org/linux-davinci/linux-davinci/trees/davinci-for-v3.9/dt-2
[2] https://gitorious.org/linux-pwm/linux-pwm/trees/for-next
[3] https://github.com/avinashphilip/am335x_linux/tree/davinci-for-v3.9_soc_pwm

Note:
DT support for EHRPWM backlight has not been added in da850-evm.dts as there is
conflicting pin-mux requirement with SPI flash.

Philip Avinash (3):
  ARM: davinci: clk framework support for enable/disable functionality
  arm: davinci: clock node support for ECAP & EHRPWM
  ARM: davinci: da850: add EHRPWM & ECAP DT node

 arch/arm/boot/dts/da850.dtsi               |   30 ++++++++++++++++++
 arch/arm/mach-davinci/clock.c              |    4 +++
 arch/arm/mach-davinci/clock.h              |    2 ++
 arch/arm/mach-davinci/da850.c              |   46 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/da8xx-dt.c           |    5 +++
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 6 files changed, 88 insertions(+)

-- 
1.7.9.5

