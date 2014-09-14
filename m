Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaINALn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 20:11:43 -0400
Received: from sender1.zohomail.com ([74.201.84.155]:30171 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaINALm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 20:11:42 -0400
From: Sorin Facaoaru <work@sorin.cc>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sorin Facaoaru <work@sorin.cc>
Subject: [PATCH] Staging: android: ion: fix coding style
Date: Sat, 13 Sep 2014 17:11:33 -0700
Message-Id: <1410653493-4559-1-git-send-email-work@sorin.cc>
X-Mailer: git-send-email 1.9.1
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_26084_0
X-ZohoMail-Owner: <1410653493-4559-1-git-send-email-work@sorin.cc>+zmo_0_<work@sorin.cc>
X-ZohoMail-Sender: 23.243.135.245
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove return statement in void function

Signed-off-by: Sorin Facaoaru <work@sorin.cc>
---
 drivers/staging/android/ion/ion_dummy_driver.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 3a45e79..ce606bd 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -152,7 +152,5 @@ static void __exit ion_dummy_exit(void)
 				dummy_heaps[ION_HEAP_TYPE_CHUNK].size);
 		chunk_ptr = NULL;
 	}
-
-	return;
 }
 __exitcall(ion_dummy_exit);
-- 
1.9.1


