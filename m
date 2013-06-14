Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3FNJ4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:56:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45674 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab3FNJ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:56:08 -0400
From: Philip Avinash <avinashphilipk@gmail.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Philip Avinash <avinashphilipk@gmail.com>
Subject: [PATCH 0/2] Fix build breakage for tnetv107x platforms
Date: Fri, 14 Jun 2013 15:27:47 +0530
Message-ID: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tnetv107x_defconfig build failing on removal selection of NEED_MACH_GPIO_H
for ARCH_DAVINCI. This is due to header files inclusion from mach/gpio-davinci.h
So this patch series fixes the build breakage on removal of NEED_MACH_GPIO_H.

This patch series is based on Linux 3.10-rc4 and is availabel at [1] and dependency on 2.

1. https://github.com/avinashphilip/am335x_linux/tree/linux_davinci_v3.10_soc_gpio_v310-rc4
2. https://patchwork.kernel.org/patch/97853/

Philip Avinash (2):
  ARM: davinci: fix for build breakage for tnetv107x platforms
  gpio: gpio-tnetv107x: Fix bulid breakge

 arch/arm/mach-davinci/board-tnetv107x-evm.c |    5 +++--
 drivers/gpio/gpio-tnetv107x.c               |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
1.7.9.5

