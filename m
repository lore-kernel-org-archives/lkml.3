Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbbA1DoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 22:44:19 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48983 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbbA1DoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 22:44:18 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com
Cc: tiwai@suse.de, perex@perex.cz, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] ASoc: Fix warning with make xmldocs caused by soc-devres.c
Date: Wed, 28 Jan 2015 12:44:27 +0900
Message-Id: <1422416667-5087-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1.30.g76afe74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix warning while "make xmldocs".

Warning(.//sound/soc/soc-devres.c:70): No description
 found for parameter 'platform_drv'
Warning(.//sound/soc/soc-devres.c:70): Excess function
 parameter 'platform' description in 'devm_snd_soc_register_platform'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/soc/soc-devres.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-devres.c b/sound/soc/soc-devres.c
index 057e5ef..a57921e 100644
--- a/sound/soc/soc-devres.c
+++ b/sound/soc/soc-devres.c
@@ -60,7 +60,7 @@ static void devm_platform_release(struct device *dev, void *res)
 /**
  * devm_snd_soc_register_platform - resource managed platform registration
  * @dev: Device used to manage platform
- * @platform: platform to register
+ * @platform_drv: platform to register
  *
  * Register a platform driver with automatic unregistration when the device is
  * unregistered.
-- 
2.3.0.rc1.30.g76afe74

