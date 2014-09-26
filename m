Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaIZNOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:14:17 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52112 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaIZNOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:14:15 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: kernel@pengutronix.de, a.zummo@towertech.it
Cc: b35083@freescale.com, rtc-linux@googlegroups.com, shawn.guo@freescale.com,
        stefan@agner.ch, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 0/3] Add SNVS clock gating and clock support to rtc-snvs driver
Date: Fri, 26 Sep 2014 18:43:58 +0530
Message-Id: <cover.1411736171.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of patches:
(1) Enable clock gating for the SNVS peripheral
(2) Adds SNVS devicetree node for the VF610 platform
(3) Add clock enable and disable support for the 
SNVS peripheral which is required by RTC. 

I would like to ask whether the solution i am
opting for in these set of patches is ok? Is there
another more appropriate solution? I couldn't find
any other piece of code which was enabling the clock
gating for the SNVS peripheral explicitly. Is this 
expected to be taken care of by uboot?

Sanchayan Maity (3):
  ARM: imx: clk-vf610: Add SNVS clock
  ARM: dts: vf610: Add SNVS node
  drivers/rtc/rtc-snvs: Add clock support

 arch/arm/boot/dts/vf610.dtsi            |   15 ++++++++++
 arch/arm/mach-imx/clk-vf610.c           |    1 +
 drivers/rtc/rtc-snvs.c                  |   48 +++++++++++++++++++++++++------
 include/dt-bindings/clock/vf610-clock.h |    3 +-
 4 files changed, 57 insertions(+), 10 deletions(-)

-- 
1.7.9.5

