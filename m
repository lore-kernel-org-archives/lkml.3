Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3J0VNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:13:40 -0400
Received: from lucifer.kyriasis.com ([106.186.112.63]:41223 "EHLO kyriasis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab3J0VNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:13:38 -0400
From: =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
Subject: [PATCH 2/2 v2] Staging: vt6656: fix code indenting error in power.c
Date: Sun, 27 Oct 2013 22:02:09 +0100
Message-Id: <1382907729-5354-1-git-send-email-johannes@kyriasis.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a code indentation error found by checkpatch.pl
where a line was indented with spaces instead of tabs

Signed-off-by: Johannes Löthberg <johannes@kyriasis.com>
---
 drivers/staging/vt6656/power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index edc8975..2c8a6b5 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -269,7 +269,7 @@ int PSbSendNullPacket(struct vnt_private *pDevice)
 		+ sizeof(struct vnt_tx_mgmt));
 
 	flags = WLAN_SET_FC_FTYPE(WLAN_TYPE_DATA) |
-                        WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL);
+			WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL);
 
 	if (pDevice->bEnablePSMode)
 		flags |= WLAN_SET_FC_PWRMGT(1);
-- 
1.8.4.1

