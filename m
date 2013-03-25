Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3CYHt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:49:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57935 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3CYHtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:49:25 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <jacmet@sunsite.dk>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v3 0/3] Platform support for EHRPWM & ECAP devices in DAVINCI.
Date: Mon, 25 Mar 2013 13:19:46 +0530
Message-ID: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform support for EHRPWM and ECAP by providing clock nodes and
device tree nodes.
This series depends on [1] and [2] and is available for testing at [3].
Tested for back light support in da850 EVM with EHRPWM PWM device.

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
 arch/arm/mach-davinci/clock.c              |   21 ++++++++-----
 arch/arm/mach-davinci/clock.h              |    2 ++
 arch/arm/mach-davinci/da850.c              |   46 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/da8xx-dt.c           |    5 +++
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
 6 files changed, 98 insertions(+), 7 deletions(-)

-- 
1.7.9.5

