Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaJMCh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:37:29 -0400
Received: from forward19.mail.yandex.net ([95.108.253.144]:50484 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaJMChZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:37:25 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 22:37:25 EDT
X-Yandex-Uniq: da5dca21-b708-4f2d-96a2-5f753c5b5895
Authentication-Results: smtp19.mail.yandex.net; dkim=pass header.i=@yandex.com
From: Erich Cordoba Malibran <erich.cordoba@yandex.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Erich Cordoba Malibran <erich.cordoba@yandex.com>
Subject: [PATCH] staging: wlan-ng: Renamed prism2_fragmenthreshold in prism2mib.c
Date: Sun, 12 Oct 2014 21:29:32 -0500
Message-Id: <1413167372-5568-1-git-send-email-erich.cordoba@yandex.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erich Cordoba Malibran <erich.cordoba@yandex.com>

Renamed function to fix style issues.

Signed-off-by: Erich Cordoba Malibran <erich.cordoba@yandex.com>
---
 drivers/staging/wlan-ng/prism2mib.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index 0163e06..30d224f 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -132,12 +132,12 @@ static int prism2mib_excludeunencrypted(struct mibrec *mib,
 					struct p80211msg_dot11req_mibset *msg,
 					void *data);
 
-static int prism2mib_fragmentationthreshold(struct mibrec *mib,
-					    int isget,
-					    wlandevice_t *wlandev,
-					    hfa384x_t *hw,
-					    struct p80211msg_dot11req_mibset *msg,
-					    void *data);
+static int prism2mib_fragmenthreshold(struct mibrec *mib,
+				      int isget,
+				      wlandevice_t *wlandev,
+				      hfa384x_t *hw,
+				      struct p80211msg_dot11req_mibset *msg,
+				      void *data);
 
 static int prism2mib_priv(struct mibrec *mib,
 			  int isget,
@@ -198,7 +198,7 @@ static struct mibrec mibtab[] = {
 	{DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
 	 F_STA | F_READ | F_WRITE,
 	 HFA384x_RID_FRAGTHRESH, 0, 0,
-	 prism2mib_fragmentationthreshold},
+	 prism2mib_fragmenthreshold},
 	{DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime,
 	 F_STA | F_READ,
 	 HFA384x_RID_MAXTXLIFETIME, 0, 0,
@@ -660,12 +660,12 @@ static int prism2mib_excludeunencrypted(struct mibrec *mib,
 *
 ----------------------------------------------------------------*/
 
-static int prism2mib_fragmentationthreshold(struct mibrec *mib,
-					    int isget,
-					    wlandevice_t *wlandev,
-					    hfa384x_t *hw,
-					    struct p80211msg_dot11req_mibset *msg,
-					    void *data)
+static int prism2mib_fragmenthreshold(struct mibrec *mib,
+				      int isget,
+				      wlandevice_t *wlandev,
+				      hfa384x_t *hw,
+				      struct p80211msg_dot11req_mibset *msg,
+				      void *data)
 {
 	int result;
 	u32 *uint32 = (u32 *) data;
-- 
2.1.2

