Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaKCOmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:42:49 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38882 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbaKCOmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:42:46 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 12/14] regulator: max77802: Use unsigned int for modes in max77802_map_mode()
Date: Mon,  3 Nov 2014 15:40:47 +0100
Message-Id: <1415025649-8119-13-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All function dealing with operating modes use unsigned int for modes
so change max77802_map_mode() function signature for consistency.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index d10c605..1d1f7b4 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -73,7 +73,7 @@ struct max77802_regulator_prv {
 	unsigned int opmode[MAX77802_REG_MAX];
 };
 
-static inline int max77802_map_mode(int mode)
+static inline unsigned int max77802_map_mode(unsigned int mode)
 {
 	return mode == MAX77802_OPMODE_NORMAL ?
 		REGULATOR_MODE_NORMAL : REGULATOR_MODE_STANDBY;
-- 
2.1.0

