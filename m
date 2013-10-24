Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3JXFi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 01:38:28 -0400
Received: from lucifer.kyriasis.com ([106.186.112.63]:36063 "EHLO kyriasis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab3JXFi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 01:38:26 -0400
From: =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres More <more.andres@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
Subject: [PATCH 1/2] Staging: vt6656: fix a brace coding style issue in power.c
Date: Thu, 24 Oct 2013 07:26:46 +0200
Message-Id: <1382592407-26728-2-git-send-email-johannes@kyriasis.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382592407-26728-1-git-send-email-johannes@kyriasis.com>
References: <1382592407-26728-1-git-send-email-johannes@kyriasis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a brace warning in power.c found by checkpatch.pl

Signed-off-by: Johannes Löthberg <johannes@kyriasis.com>
---
 drivers/staging/vt6656/power.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index edc8975..3002061 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -233,9 +233,8 @@ void PSvSendPSPOLL(struct vnt_private *pDevice)
 	pTxPacket->cbPayloadLen = 0;
 
 	/* log failure if sending failed */
-	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
+	if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING)
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send PS-Poll packet failed..\n");
-	}
 }
 
 /*
-- 
1.8.4.1

