Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaK1CVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:21:47 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:48711 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaK1CVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:21:45 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <xuwei5@hisilicon.com>, <arnd@arndb.de>, <yanhaifeng@gmail.com>,
        <zhangfei.gao@linaro.org>, <haojian.zhuang@linaro.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <jason@lakedaemon.net>, <jh80.chung@samsung.com>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <long.wanglong@huawei.com>, <mark.rutland@arm.com>,
        <maxime.ripard@free-electrons.com>, <obh+dt@kernel.org>,
        <olof@lixom.net>, <pawel.moll@arm.com>, <swarren@nvidia.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH 0/7] ARM: hisi: enable HiP01 SoC
Date: Fri, 28 Nov 2014 02:15:43 +0000
Message-ID: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series patch enable Hisilicon HiP01 SoC. The HiP01 SoC series
chip is designed for networking product, it integrates a rich peripheral
interfaces to support network applications and supports both one 
core or dual cores and quad cores. The core is Cortex A9. 

Wang Long (7):
  ARM: debug: add HiP01 debug uart
  ARM: hisi: enable HiP01 SoC
  ARM: dts: Add hip01-ca9x2 dts file
  ARM: config: enable ARCH_HIP01
  ARM: hisi: add a common smp_prepares_cpus function
  ARM: hisi: rename secondary_startup function
  ARM: hisi: enable smp for HiP01

 .../bindings/arm/hisilicon/hisilicon.txt           |  25 +++++
 arch/arm/Kconfig.debug                             |  10 ++
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/hip01-ca9x2.dts                  |  52 ++++++++++
 arch/arm/boot/dts/hip01.dtsi                       | 110 +++++++++++++++++++++
 arch/arm/configs/hisi_defconfig                    |   1 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 arch/arm/mach-hisi/Kconfig                         |   8 ++
 arch/arm/mach-hisi/core.h                          |   5 +-
 arch/arm/mach-hisi/headsmp.S                       |   2 +-
 arch/arm/mach-hisi/hisilicon.c                     |  10 ++
 arch/arm/mach-hisi/hotplug.c                       |  31 ++++++
 arch/arm/mach-hisi/platsmp.c                       |  56 ++++++++++-
 13 files changed, 307 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/boot/dts/hip01-ca9x2.dts
 create mode 100644 arch/arm/boot/dts/hip01.dtsi

-- 
1.8.3.4

