Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000AbaGCO25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:28:57 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35827 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964973AbaGCO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:28:53 -0400
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>, arnd@arndb.de,
        mark.rutland@arm.com, haifeng.yan@linaro.org, jchxue@gmail.com,
        zhangfei.gao@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 0/2] phy: add hix5hd2-sata-phy driver
Date: Thu,  3 Jul 2014 22:28:36 +0800
Message-Id: <1404397718-11495-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
Suggested by Kishon
Change binding doc name to hix5hd2-phy.txt
Add HAS_IOMEM depends, and change include file sequence

v2:
Suggested by Mark
Remove hisilicon,reg-init and init the register in phy-hix5hd2-sata.c
Change property name accordingly.

Jiancheng Xue (2):
  Documentation: Document Hisilicon hix5hd2 sata PHY
  phy: add hix5hd2-sata-phy driver

 .../devicetree/bindings/phy/hix5hd2-phy.txt        |   22 +++
 drivers/phy/Kconfig                                |    8 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-hix5hd2-sata.c                     |  192 ++++++++++++++++++++
 4 files changed, 223 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-phy.txt
 create mode 100644 drivers/phy/phy-hix5hd2-sata.c

-- 
1.7.9.5

