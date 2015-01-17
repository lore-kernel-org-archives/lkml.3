Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbbAQOxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 09:53:54 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35665 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbbAQOxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 09:53:52 -0500
From: Peter Poklop <peter.poklop@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter <peter.poklop@gmail.com>
Subject: [PATCH] Staging: rtl8723au: fix space coding style issue in os_intfs.c
Date: Sat, 17 Jan 2015 15:52:45 +0100
Message-Id: <1421506365-9171-1-git-send-email-peter.poklop@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter <peter.poklop@gmail.com>

This patch fixes the checkpatch.pl warning:

WARNING: space prohibited before semicolon

Signed-off-by: Peter Poklop <peter.poklop@gmail.com>
---
 drivers/staging/rtl8723au/os_dep/os_intfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index 9966d16..1b23eb1 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -91,7 +91,7 @@ static int rtw_bt_iso = 2;/*  0:Low, 1:High, 2:From Efuse */
 /*  0:Idle, 1:None-SCO, 2:SCO, 3:From Counter, 4.Busy, 5.OtherBusy */
 static int rtw_bt_sco = 3;
 /*  0:Disable BT control A-MPDU, 1:Enable BT control A-MPDU. */
-static int rtw_bt_ampdu = 1 ;
+static int rtw_bt_ampdu = 1;
 #endif
 
 /*  0:Reject AP's Add BA req, 1:Accept AP's Add BA req. */
-- 
2.1.0

