Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3FDO0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:26:22 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61154 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3FDO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:26:18 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, guodong.xu@linaro.org
Subject: [PATCH 0/3] regulator: add driver for Hi6421 PMIC SoC
Date: Tue,  4 Jun 2013 22:28:40 +0800
Message-Id: <1370356123-22357-1-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a core driver and regulators driver for Hi6421 PMIC SoC.

Hi6421 is a PMIC SoC designed and manufactured by HiSilicon Ltd. It includes
multi-functions, such as regulators, codec, ADCs, Coulomb counter, etc.

Hi6421 can be reused in various Hi3620 based boards. Memory-mapped I/O is
the way used by application processor to communicate with Hi6421.

Guodong Xu (3):
  mfd: Add hi6421 PMIC core driver
  regulator: add driver for hi6421 voltage regulator
  ARM: dts: add dedicated dtsi for hi6421

 .../bindings/regulator/hi6421-regulator.txt        |   82 +++
 arch/arm/boot/dts/hi6421.dtsi                      |  489 +++++++++++++++++
 drivers/mfd/Kconfig                                |   11 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/hi6421-pmic-core.c                     |  171 ++++++
 drivers/regulator/Kconfig                          |    8 +-
 drivers/regulator/Makefile                         |    2 +-
 drivers/regulator/hi6421-regulator.c               |  559 ++++++++++++++++++++
 include/linux/mfd/hi6421-pmic.h                    |   55 ++
 9 files changed, 1376 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/hi6421-regulator.txt
 create mode 100644 arch/arm/boot/dts/hi6421.dtsi
 create mode 100644 drivers/mfd/hi6421-pmic-core.c
 create mode 100644 drivers/regulator/hi6421-regulator.c
 create mode 100644 include/linux/mfd/hi6421-pmic.h

-- 
1.7.4.1

