Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbaKAC62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:58:28 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:60562 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaKAC61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:58:27 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <95f895a36cc124e0fdac1ad3623e4314>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH v2] ASoC: rockchip: i2s: add text after tristate for SND_SOC_ROCKCHIP_I2S
Date: Sat,  1 Nov 2014 10:58:18 +0800
Message-Id: <1414810698-5609-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
References: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For SND_SOC_ROCKCHIP_I2S, adding some text after the
tristate to make this directly user selectable.

Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
changes since v1:
-to make this directlyuser selectable by adding some text after
the tristate as well as the rest, suggested by Mark
-to use the existing MAX98090 entry, not duplicate it, so remove
related codes, suggested by Mark

 sound/soc/rockchip/Kconfig | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index 78fc159..b1fc0ca 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -8,4 +8,9 @@ config SND_SOC_ROCKCHIP
 	  select the audio interfaces to support below.
 
 config SND_SOC_ROCKCHIP_I2S
-	tristate
+	tristate "Rockchip I2S Device Driver"
+	depends on CLKDEV_LOOKUP
+	help
+	  Say Y or M if you want to add support for I2S driver for
+	  Rockchip I2S device. The device supports upto maximum of
+	  8 channels each for play and record.
-- 
1.9.1


