Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3EaDJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:09:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:2745 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3EaDJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:09:46 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <wim@iguana.be>, <linux@arm.linux.org.uk>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>,
        <richard.genoud@gmail.com>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>, <jm.lin@atmel.com>
Subject: [PATCH 0/2] ARM: dts: add watchdog device tree node in at91 dts files  
Date: Fri, 31 May 2013 11:09:04 +0800
Message-ID: <1369969744-3428-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The patches is to add watchdog device tree node for at91 SoC and board dts files.

Since the watchdog is disabled in the at91bootstrap with default configuration,
if you want to use the watchdog in the kernel, you must make sure the watchdog
doesn't be disabled in the at91bootstrap.

It is tested on at91sam9g20ek, at91sam9263ek, at91sam9g25ek
using Documentation/watchdog/src/watchdog-simple.c.

It is based on v3.10-rc3, tested on linux-watchdog git tree as well.

Best Regards,
Wenyou Yang

Wenyou Yang (2):
  ARM: dts: add the watchdog nodes for at91 SoC
  ARM: dts: add the watchdog nodes for at91 boards

 arch/arm/boot/dts/at91sam9263ek.dts         |    4 ++++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi |    4 ++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts      |    4 ++++
 arch/arm/boot/dts/at91sam9n12.dtsi          |    6 ++++++
 arch/arm/boot/dts/at91sam9n12ek.dts         |    4 ++++
 arch/arm/boot/dts/at91sam9x5.dtsi           |    6 ++++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi         |    4 ++++
 7 files changed, 32 insertions(+)

-- 
1.7.9.5

