Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab3E2DLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:11:11 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:56086 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759483Ab3E2DLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:11:10 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <haojian.zhuang@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] bring up pxa988 with DT
Date: Wed, 29 May 2013 11:10:41 +0800
Message-ID: <1369797042-22174-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is supposed to bring up pxa988 SMP.
will change to use CLOCKSOURCE later.

Neil Zhang (1):
  ARM: mmp: bring up pxa988 with device tree support

 arch/arm/boot/dts/pxa988-dkb.dts          |   36 ++++++
 arch/arm/boot/dts/pxa988.dtsi             |  189 +++++++++++++++++++++++++++++
 arch/arm/mach-mmp/Kconfig                 |   27 ++++
 arch/arm/mach-mmp/Makefile                |    2 +
 arch/arm/mach-mmp/common.c                |   11 ++-
 arch/arm/mach-mmp/common.h                |    2 +
 arch/arm/mach-mmp/headsmp.S               |  104 ++++++++++++++++
 arch/arm/mach-mmp/include/mach/addr-map.h |    6 +
 arch/arm/mach-mmp/mmpx-dt.c               |   74 +++++++++++
 arch/arm/mach-mmp/platsmp.c               |  163 +++++++++++++++++++++++++
 arch/arm/mach-mmp/reset.c                 |   66 ++++++++++
 arch/arm/mach-mmp/reset.h                 |   29 +++++
 drivers/clk/mmp/Makefile                  |    1 +
 13 files changed, 709 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/boot/dts/pxa988-dkb.dts
 create mode 100644 arch/arm/boot/dts/pxa988.dtsi
 create mode 100644 arch/arm/mach-mmp/headsmp.S
 create mode 100644 arch/arm/mach-mmp/mmpx-dt.c
 create mode 100644 arch/arm/mach-mmp/platsmp.c
 create mode 100644 arch/arm/mach-mmp/reset.c
 create mode 100644 arch/arm/mach-mmp/reset.h

-- 
1.7.4.1

