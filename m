Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3ESNao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 09:30:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57712 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3ESNam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 09:30:42 -0400
From: Jakob Normark <jakobnormark@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakob Normark <jakobnormark@gmail.com>
Subject: [PATCH 1/1] Missing break statement added in smsdvb-main.c
Date: Sun, 19 May 2013 15:30:23 +0200
Message-Id: <1368970223-3280-1-git-send-email-jakobnormark@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing break that so that n_layers are not accidentally incorrect

Kernel version: v3.10-rc1

Signed-off-by: Jakob Normark <jakobnormark@gmail.com>
---
 drivers/media/common/siano/smsdvb-main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 297f1b2..0862622 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -140,6 +140,7 @@ static void smsdvb_stats_not_ready(struct dvb_frontend *fe)
 	case DEVICE_MODE_ISDBT:
 	case DEVICE_MODE_ISDBT_BDA:
 		n_layers = 4;
+		break;
 	default:
 		n_layers = 1;
 	}
-- 
1.7.9.5

