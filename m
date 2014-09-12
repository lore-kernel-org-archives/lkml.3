Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaILH3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:29:14 -0400
Received: from regular2.263xmail.com ([211.157.152.4]:56394 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaILH3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:29:11 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <90556731e489c2d90ff889a87703964f>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, heiko@sntech.de,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com
Subject: [PATCH 0/2] rockchip-max98090: add driver for rockchip board with max98090
Date: Fri, 12 Sep 2014 15:26:46 +0800
Message-Id: <1410506806-15327-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch to add driver for rockchip board using a max98090.

Tested on RK3288 using a max98090.

Jianqun (2):
  ASoC: rockchip-max98090: add documentation for rockchip-max98090
    driver
  ASoC: rockchip-max98090: add driver for rockchip board using a
    max98090

 .../sound/rockchip,rockchip-audio-max98090.txt     |  23 ++
 sound/soc/rockchip/Kconfig                         |   9 +
 sound/soc/rockchip/Makefile                        |   5 +-
 sound/soc/rockchip/rockchip_max98090.c             | 308 +++++++++++++++++++++
 4 files changed, 344 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.txt
 create mode 100644 sound/soc/rockchip/rockchip_max98090.c

-- 
1.9.1


