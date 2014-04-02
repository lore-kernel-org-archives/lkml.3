Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbaDBRzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:55:47 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:54114 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775AbaDBRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:55:44 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, forest@alittletooquiet.net,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        driverdev-devel@linuxdriverproject.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH v2 2/4] staging: vt6655: remove mention of nonexistent function CARDbSetBasicRate
Date: Wed,  2 Apr 2014 14:53:02 -0300
Message-Id: <1396461184-13231-3-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
 <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments mention a function CARDbSetBasicRate, but it never existed in
the source tree. Remove all mention of it.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
 drivers/staging/vt6655/card.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index db38ca0..e722795 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -24,7 +24,6 @@
  *      vUpdateIFS - Update slotTime,SIFS,DIFS, and EIFS
  *      CARDvUpdateBasicTopRate - Update BasicTopRate
  *      CARDbAddBasicRate - Add to BasicRateSet
- *      CARDbSetBasicRate - Set Basic Tx Rate
  *      CARDbIsOFDMinBasicRate - Check if any OFDM rate is in BasicRateSet
  *      CARDvSetLoopbackMode - Set Loopback mode
  *      CARDbSoftwareReset - Sortware reset NIC
@@ -1877,19 +1876,6 @@ void CARDvUpdateBasicTopRate(void *pDeviceHandler)
 	pDevice->byTopCCKBasicRate = byTopCCK;
 }
 
-/*
- * Description: Set NIC Tx Basic Rate
- *
- * Parameters:
- *  In:
- *      pDevice         - The adapter to be set
- *      wBasicRate      - Basic Rate to be set
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
 bool CARDbAddBasicRate(void *pDeviceHandler, unsigned short wRateIdx)
 {
 	PSDevice pDevice = (PSDevice) pDeviceHandler;
-- 
1.9.0

