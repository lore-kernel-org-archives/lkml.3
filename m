Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3JAPmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:42:54 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58615 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3JAPmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:42:51 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [Add SMP support for Allwinner A20: PATCH V4 0/3] 
Date: Tue,  1 Oct 2013 23:42:22 +0800
Message-Id: <1380642145-17295-1-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the version 4 patch. It use smp_prepare_cpus replacing early_init as cpuconfigure map init funcation caller and use sun7i replacing sunxi7i as funcation name and variable name.

Fan Rong (3):
  Add smp support for Allwinner A20(sunxi 7i).
  Add cpuconfig nodes in dts for smp configure.
  Add arch count timer node in dts for Allwinner A20(sunxi 7i).

 arch/arm/boot/dts/sun7i-a20.dtsi |  15 ++++++
 arch/arm/mach-sunxi/Makefile     |   2 +
 arch/arm/mach-sunxi/headsmp.S    |  18 +++++++
 arch/arm/mach-sunxi/platsmp.c    | 114 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/sunxi.c      |   3 ++
 5 files changed, 152 insertions(+)
 create mode 100644 arch/arm/mach-sunxi/headsmp.S
 create mode 100644 arch/arm/mach-sunxi/platsmp.c

-- 
1.8.1.2

