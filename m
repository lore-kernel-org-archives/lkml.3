Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaKSDNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:13:24 -0500
Received: from irl-smtp01.263.net ([54.76.167.174]:34621 "EHLO
	irl-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaKSDNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:13:23 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2014 22:13:22 EST
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <e8d970f6d04df03eb706c292e7b08c4b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun Xu <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, huangtao@rock-chips.com
Cc: Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH 0/2] ASoC: rockchip: i2s: add support for grabbing output clock to codec
Date: Wed, 19 Nov 2014 11:06:03 +0800
Message-Id: <1416366365-4632-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference to Chapter 3 Clock & Reset Unit (CRU) of RK3288 TRM, i2s0_clkout has
two source clock, XIN24M_DIV2 for 12M and clk_i2s0 for more kinds of
frequencies, I2S0(i2s_clk) has only single source clock clk_i2s0.

i2s0_clkout: generate to output to outside of chip, generally for codec
I2S0(i2s_clk): generate for i2s controller inside of chip

Jianqun Xu (2):
  ASoC: rockchip-i2s: dt: add i2s_clkout to list of clocks
  ASoC: rockchip: i2s: add support for grabbing output clock to codec

 Documentation/devicetree/bindings/sound/rockchip-i2s.txt |  5 +++--
 sound/soc/rockchip/rockchip_i2s.c                        | 11 +++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

-- 
1.9.1

