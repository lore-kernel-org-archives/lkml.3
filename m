Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaFXEFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:05:10 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:36785 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaFXEFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:05:06 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2014 00:05:06 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <75dbdf9b9cb66f29b7c0400a6115fd6c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: addy ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        addy ke <addy.ke@rock-chips.com>
Subject: [PATCH 0/2] add rockchip spi drive
Date: Tue, 24 Jun 2014 11:58:42 +0800
Message-Id: <1403582324-9485-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 add rockchip spi documentation
Patch 2 add driver for Rockchip RK3XXX SoCs integrated SPI.

Tested on rk3288 sdk board with polling mode and DMA mode.

addy ke (2):
  documentation: add rockchip spi documentation
  spi: add driver for Rockchip RK3xxx SoCs integrated SPI

 .../devicetree/bindings/spi/spi-rockchip.txt       |  51 ++
 drivers/spi/Kconfig                                |  11 +
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-rockchip.c                         | 894 +++++++++++++++++++++
 4 files changed, 957 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-rockchip.txt
 create mode 100644 drivers/spi/spi-rockchip.c

-- 
1.8.3.2


