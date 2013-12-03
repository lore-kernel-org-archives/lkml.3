Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3LCUIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:08:16 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57516 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LCUIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:08:15 -0500
X-Originating-IP: 176.58.169.25
From: Aldo Iljazi <mail@aldo.io>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, kirk@reisers.ca, samuel.thibault@ens-lyon.org,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: speakup: synth.c: removed a space
Date: Tue,  3 Dec 2013 22:08:03 +0200
Message-Id: <1386101283-14650-1-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line 468: Removed a space before a semicolon.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 drivers/staging/speakup/synth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 0b3549b..2a4b348 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -465,7 +465,7 @@ void synth_remove(struct spk_synth *in_synth)
 		if (in_synth == synths[i])
 			break;
 	}
-	for ( ; synths[i] != NULL; i++) /* compress table */
+	for (; synths[i] != NULL; i++) /* compress table */
 		synths[i] = synths[i+1];
 	module_status = 0;
 	mutex_unlock(&spk_mutex);
-- 
1.8.3.2

