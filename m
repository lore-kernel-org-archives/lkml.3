Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaKKPwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:52:44 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43960 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaKKPwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:52:41 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, tiwai@suse.de, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [linux-next] sound: soc: Fix warning while make htmldocs caused by soc-jack.c
Date: Wed, 12 Nov 2014 00:52:23 +0900
Message-Id: <1415721143-13914-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix following errors while "make htmldocs" on
linux-next-20141110.

Warning(.//sound/soc/soc-jack.c:126): No description found for
parameter 'zones'
Warning(.//sound/soc/soc-jack.c:126): Excess function parameter
'zone' description in 'snd_soc_jack_add_zones'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/soc/soc-jack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index f921d00..4380dcc 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -116,7 +116,7 @@ EXPORT_SYMBOL_GPL(snd_soc_jack_report);
  *
  * @jack:  ASoC jack
  * @count: Number of zones
- * @zone:  Array of zones
+ * @zones:  Array of zones
  *
  * After this function has been called the zones specified in the
  * array will be associated with the jack.
-- 
2.2.0.rc1

