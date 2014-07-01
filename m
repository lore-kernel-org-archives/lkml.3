Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbaGAIpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:45:15 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:59942 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbaGAIpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:45:12 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 04:45:11 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <36f04e84acb0e7684582dc301d773e1a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: jianqun <xjq@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, zhangqing@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com, Jianqun Xu <xjq@rock-chips.com>
Subject: [PATCH 0/2] add rockchip i2s driver
Date: Tue,  1 Jul 2014 16:37:38 +0800
Message-Id: <1404203860-30712-1-git-send-email-xjq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianqun Xu <xjq@rock-chips.com>

This patch is to add driver for I2S controller in RK3xxx SoCs.

Jianqun Xu (2):
  ASoC: dt-bindings: add rockchip i2s bindings
  ASoC: add driver for Rockchip RK3xxx I2S controller

 .../devicetree/bindings/sound/rockchip-i2s.txt     |   45 ++
 sound/soc/Kconfig                                  |    1 +
 sound/soc/Makefile                                 |    1 +
 sound/soc/rockchip/Kconfig                         |   16 +
 sound/soc/rockchip/Makefile                        |    6 +
 sound/soc/rockchip/i2s.h                           |  222 +++++++
 sound/soc/rockchip/pcm.h                           |   14 +
 sound/soc/rockchip/rockchip_i2s.c                  |  622 ++++++++++++++++++++
 sound/soc/rockchip/rockchip_pcm.c                  |   64 ++
 9 files changed, 991 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/rockchip-i2s.txt
 create mode 100644 sound/soc/rockchip/Kconfig
 create mode 100644 sound/soc/rockchip/Makefile
 create mode 100644 sound/soc/rockchip/i2s.h
 create mode 100644 sound/soc/rockchip/pcm.h
 create mode 100644 sound/soc/rockchip/rockchip_i2s.c
 create mode 100644 sound/soc/rockchip/rockchip_pcm.c

-- 
1.7.9.5


