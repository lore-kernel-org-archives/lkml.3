Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaFQH6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:58:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38572 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaFQH6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:58:11 -0400
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>, arnd@arndb.de,
        mark.rutland@arm.com, haifeng.yan@linaro.org, jchxue@gmail.com,
        zhangfei.gao@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/2] phy: add hix5hd2-sata-phy driver
Date: Tue, 17 Jun 2014 15:57:59 +0800
Message-Id: <1402991881-27676-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiancheng Xue (2):
  Documentation: Document Hisilicon hix5hd2 sata PHY
  phy: add hix5hd2-sata-phy driver

 .../devicetree/bindings/phy/hix5hd2-sata-phy.txt   |   26 +++
 drivers/phy/Kconfig                                |    8 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-hix5hd2-sata.c                     |  192 ++++++++++++++++++++
 4 files changed, 227 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
 create mode 100644 drivers/phy/phy-hix5hd2-sata.c

-- 
1.7.9.5

