Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaGKCJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:09:40 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:56225 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaGKCJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:09:38 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <0b5c51fda1cb084def485a9de0ece560>
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
Subject: [PATCH 4/4] spi/rockchip: add compatible strings for RK3188 and RK3288
Date: Fri, 11 Jul 2014 10:09:19 +0800
Message-Id: <1405044559-7009-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405044389-6800-1-git-send-email-addy.ke@rock-chips.com>
References: <1405044389-6800-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Addy Ke <addy.ke@rockchip.com>

Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Addy Ke <addy.ke@rockchip.com>
---
 drivers/spi/spi-rockchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index a8866c9..cb8fd6f 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -814,6 +814,8 @@ static const struct dev_pm_ops rockchip_spi_pm = {
 
 static const struct of_device_id rockchip_spi_dt_match[] = {
 	{ .compatible = "rockchip,rk3066-spi", },
+	{ .compatible = "rockchip,rk3188-spi", },
+	{ .compatible = "rockchip,rk3288-spi", },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rockchip_spi_dt_match);
-- 
1.8.3.2


