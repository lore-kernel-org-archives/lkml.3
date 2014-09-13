Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaIMBQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 21:16:48 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:50414 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685AbaIMBQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 21:16:47 -0400
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <3a616203996520249eaa4e4c2eade93b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH 0/5] ASoC: rockchip-i2s: patches for rockchip i2s driver
Date: Sat, 13 Sep 2014 08:38:43 +0800
Message-Id: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches to fix rockchip i2s driver bugs, also make driver codes
reasonable.
Tested on RK3288 board.

Jianqun (5):
  ASoC: rockchip-i2s: fix rockchip i2s defination more reasonable
  ASoC: rockchip-i2s: fix master mode set bit error
  ASoC: rockchip-i2s: add dma data to snd_soc_dai
  ASoC: rockchip-i2s: fix registers' property of rockchip i2s controller
  ASoC: rockchip-i2s: enable "hclk" for rockchip I2S controller

 sound/soc/rockchip/Kconfig        |  3 +--
 sound/soc/rockchip/Makefile       |  2 +-
 sound/soc/rockchip/rockchip_i2s.c | 41 ++++++++++++++++++++++++---------------
 3 files changed, 27 insertions(+), 19 deletions(-)

-- 
1.9.1

