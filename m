Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3JXFiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 01:38:21 -0400
Received: from lucifer.kyriasis.com ([106.186.112.63]:36062 "EHLO kyriasis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab3JXFiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 01:38:21 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 01:38:20 EDT
From: =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres More <more.andres@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>
Subject: [PATCH 2/2] Staging: vt6656: fix code indenting error in power.c
Date: Thu, 24 Oct 2013 07:26:47 +0200
Message-Id: <1382592407-26728-3-git-send-email-johannes@kyriasis.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382592407-26728-1-git-send-email-johannes@kyriasis.com>
References: <1382592407-26728-1-git-send-email-johannes@kyriasis.com>
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
index 3002061..a14a2bf 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -268,7 +268,7 @@ int PSbSendNullPacket(struct vnt_private *pDevice)
 		+ sizeof(struct vnt_tx_mgmt));
 
 	flags = WLAN_SET_FC_FTYPE(WLAN_TYPE_DATA) |
-                        WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL);
+		WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL);
 
 	if (pDevice->bEnablePSMode)
 		flags |= WLAN_SET_FC_PWRMGT(1);
-- 
1.8.4.1

