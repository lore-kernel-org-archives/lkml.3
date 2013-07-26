Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3GZNBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:01:45 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:54056 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3GZNBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:01:42 -0400
Message-ID: <1374843691.1802.5.camel@desktop>
Subject: [PATCH 2/2] Staging: bcm: InterfaceIdleMode: Fixed brace issues
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, klmckinney1@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Jul 2013 21:01:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed brace issues

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/InterfaceIdleMode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceIdleMode.c
b/drivers/staging/bcm/InterfaceIdleMode.c
index 0c93048..4f88dd8 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -95,8 +95,7 @@ int InterfaceIdleModeRespond(struct bcm_mini_adapter
*Adapter, unsigned int *pui
 			wake_up(&Adapter->lowpower_mode_wait_queue);
 
 		} else {
-			if (TRUE == Adapter->IdleMode)
-			{
+			if (TRUE == Adapter->IdleMode) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"Device is already in Idle mode....");
 				return status;
 			}
@@ -168,8 +167,7 @@ static int InterfaceAbortIdlemode(struct
bcm_mini_adapter *Adapter, unsigned int
 	if (Adapter->ulPowerSaveMode ==
DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING) {
 		value = 0x80000000;
 		status = wrmalt(Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR, &value,
sizeof(value));
-		if (status)
-		{
+		if (status) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
"WRM to DEBUG_INTERRUPT_GENERATOR_REGISTOR Register failed");
 			return status;
 		}
-- 
1.8.3.1



