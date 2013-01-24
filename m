Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3AXIhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:37:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50399 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab3AXIhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:37:34 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <hs@denx.de>, <anilkumar.v@ti.com>
Subject: [PATCH 0/2] ARM: davinci: da850: add wdt DT node
Date: Thu, 24 Jan 2013 14:08:13 +0530
Message-ID: <1359016695-10362-1-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add wdt DT node and OF_DEV_AUXDATA for wdt driver in
da850 board dt file to use wdt clock.

This series applies on top of v3.8-rc4.

This is tested on da850 EVM.

Test Procedure:

$watchdog -F /dev/watchdog (Device should not reboot)
 After wdt heartbeat timeout(DEFAULT_HEARTBEAT is 60 sec)
$ctr + c   (Device should reboot after heartbeat timeout)

Kumar, Anil (2):
  ARM: davinci: da850: add wdt DT node
  ARM: davinci: da850: add wdt OF_DEV_AUXDATA entry

 arch/arm/boot/dts/da850-evm.dts  |    3 +++
 arch/arm/boot/dts/da850.dtsi     |    5 +++++
 arch/arm/mach-davinci/da8xx-dt.c |    8 +++++++-
 3 files changed, 15 insertions(+), 1 deletions(-)

-- 
1.7.4.1

