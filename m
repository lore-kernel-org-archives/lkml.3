Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3IGWwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 18:52:09 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:36020 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3IGWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 18:52:02 -0400
From: Sean Williams <unixed@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Sean Williams <unixed@gmail.com>
Subject: [PATCH] Staging: Remove a few superfluous braces
Date: Sat,  7 Sep 2013 15:51:34 -0700
Message-Id: <1378594294-13653-1-git-send-email-unixed@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't flame me :) I'm getting my feet wet with kernel contribution.
One example I saw in a video by GKH suggested cleaning up coding style as a good first commit.

Signed-off-by: Sean Williams <unixed@gmail.com>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 2512ce8..c77d343 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -684,13 +684,12 @@ static int a2150_set_chanlist(struct comedi_device *dev,
 		devpriv->config_bits |= CHANNEL_BITS(0x4 | start_channel);
 		break;
 	case 2:
-		if (start_channel == 0) {
+		if (start_channel == 0)
 			devpriv->config_bits |= CHANNEL_BITS(0x2);
-		} else if (start_channel == 2) {
+		else if (start_channel == 2)
 			devpriv->config_bits |= CHANNEL_BITS(0x3);
-		} else {
+		else
 			return -1;
-		}
 		break;
 	case 4:
 		devpriv->config_bits |= CHANNEL_BITS(0x1);
-- 
1.8.1.2

