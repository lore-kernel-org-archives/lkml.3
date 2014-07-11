Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaGKCGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:06:55 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:47133 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaGKCGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:06:54 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <457fc2b570e61ea69a475553f49deb63>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        jogo@openwrt.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        wei.luo@rock-chips.com, Addy Ke <addy.ke@rockchip.com>
Subject: [PATCH 0/4] patches for rockchip spi driver
Date: Fri, 11 Jul 2014 10:06:29 +0800
Message-Id: <1405044389-6800-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Addy Ke <addy.ke@rockchip.com>

These patches based on:
- git: kernel/git/broonie/spi.git
- branch: topic/rockchip
- commit: c15369087ae5c7db7f3e3604822eac6ab87429bd

Addy Ke (4):
  spi/rockchip: cleanup some coding issues and uncessary output
  spi/rockchip: call wait_for_idle() for the transfer to complete
  spi/rockchip: master->mode_bits: remove SPI_CS_HIGH bit
  spi/rockchip: add compatible strings for RK3188 and RK3288

 drivers/spi/spi-rockchip.c | 74 ++++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

-- 
1.8.3.2


