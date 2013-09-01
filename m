Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3IAWlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:41:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40423 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754452Ab3IAWlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:41:02 -0400
Message-ID: <1378075260.1953.25.camel@joe-AO722>
Subject: [PATCH staging-next] staging: vt6655: Remove commented out block
 with compare_ether_addr
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 01 Sep 2013 15:41:00 -0700
In-Reply-To: <1378062947.1953.9.camel@joe-AO722>
References: <1378061483.1953.3.camel@joe-AO722>
	 <1378062947.1953.9.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compare_ether_addr is being removed so remove
even the commented out code referring to it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/vt6655/vntwifi.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index d8f4f8e..d2bdb71 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -752,25 +752,3 @@ VNTWIFIbChannelSwitch(
 	//spin_unlock_irq(&pDevice->lock);
 	return true;
 }
-
-/*
-  bool
-  VNTWIFIbRadarPresent(
-  void *pMgmtObject,
-  unsigned char byChannel
-) {
-  PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
-  if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) &&
-  (byChannel == (unsigned char) pMgmt->uCurrChannel) &&
-  (pMgmt->bSwitchChannel != true) &&
-  (pMgmt->b11hEnable == true)) {
-  if (!compare_ether_addr(pMgmt->abyIBSSDFSOwner, CARDpGetCurrentAddress(pMgmt->pAdapter))) {
-  pMgmt->byNewChannel = CARDbyAutoChannelSelect(pMgmt->pAdapter,(unsigned char) pMgmt->uCurrChannel);
-  pMgmt->bSwitchChannel = true;
-  }
-  BEACONbSendBeacon(pMgmt);
-  CARDbChannelSwitch(pMgmt->pAdapter, 0, pMgmt->byNewChannel, 10);
-  }
-  return true;
-  }
-*/


