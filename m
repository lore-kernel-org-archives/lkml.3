Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbaHVPzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:55:09 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:38337 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaHVPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:55:07 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 00/11] ARM: multi_v7_defconfig: Enable Zynq/Xilinx drivers
Date: Fri, 22 Aug 2014 08:54:25 -0700
Message-Id: <1408722876-7791-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I went through the defconfig and searched for Zynq drivers. The result is
this series of patches. The first few are all for Zynq and pretty much
straight forward. The second half is mostly soft-IP, I think. That
soft-IP works with Zynq devices, but I'm not sure whether those should
go into the multi_v7 defconfig.

	Soren

Soren Brinkmann (11):
  ARM: multi_v7_defconfig: Enable Zynq cpuidle driver
  ARM: multi_v7_defconfig: Enable Zynq/Xilinx CAN driver
  ARM: multi_v7_defconfig: Enable XADC driver
  ARM: multi_v7_defconfig: Enable Zynq SPI driver
  ARM: multi_v7_defconfig: Enable Zynq GPIO driver
  ARM: multi_v7_defconfig: Enable Xilinx I2C driver
  ARM: multi_v7_defconfig: Enable Xilinx SPI driver
  ARM: multi_v7_defconfig: Enable Xilinx GPIO driver
  ARM: multi_v7_defconfig: Enable Xilinx VDMA driver
  ARM: multi_v7_defconfig: Enable Xilinx emaclite driver
  ARM: multi_v7_defconfig: Enable Xilinx watchdog timer

 arch/arm/configs/multi_v7_defconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

-- 
2.0.1.1.gfbfc394

