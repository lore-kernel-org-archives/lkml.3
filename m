Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaJGBqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 21:46:09 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:36209 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJGBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 21:46:08 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <b6a253b34591ab65a178690f721fa272>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, heiko@sntech.de,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] rockchip-max98090: add driver for rockchip board with max98090
Date: Tue,  7 Oct 2014 09:43:55 +0800
Message-Id: <1412646237-9369-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches add driver for rockchip board using a max98090. This could be
replaced with simple-card driver but it not work well now.

Tested on RK3288 using a max98090.


Jianqun (2):
  ASoC: rockchip-max98090: add driver for rockchip board using a
    max98090
  ASoC: rockchip-max98090: add documentation for rockchip-max98090
    driver

 .../sound/rockchip,rockchip-audio-max98090.txt     |  23 ++
 sound/soc/rockchip/Kconfig                         |   9 +
 sound/soc/rockchip/Makefile                        |   5 +-
 sound/soc/rockchip/rockchip_max98090.c             | 346 +++++++++++++++++++++
 4 files changed, 382 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/sound/rockchip,rockchip-audio-max98090.txt
 create mode 100644 sound/soc/rockchip/rockchip_max98090.c

-- 
1.9.1


