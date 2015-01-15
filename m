Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbbAOK3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:29:37 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34877 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbAOK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:29:35 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        broonie@kernel.org, tiwai@suse.de
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] ASoC: Fix typo in bt-sco.c
Date: Thu, 15 Jan 2015 19:29:28 +0900
Message-Id: <1421317768-17707-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo in bt-sco.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/soc/codecs/bt-sco.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/bt-sco.c b/sound/soc/codecs/bt-sco.c
index 5075bf0..e7238b8 100644
--- a/sound/soc/codecs/bt-sco.c
+++ b/sound/soc/codecs/bt-sco.c
@@ -86,5 +86,5 @@ static struct platform_driver bt_sco_driver = {
 module_platform_driver(bt_sco_driver);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
-MODULE_DESCRIPTION("ASoC generic bluethooth sco link driver");
+MODULE_DESCRIPTION("ASoC generic bluetooth sco link driver");
 MODULE_LICENSE("GPL");
-- 
2.3.0.rc0

