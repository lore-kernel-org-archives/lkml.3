Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaFFRzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:55:33 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:41302 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaFFRzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:55:32 -0400
From: Chuong Ngo <cngo.linux@gmail.com>
To: gregkh@linuxfoundation.org
Cc: mail@beyermatthias.de, lisa@xenapiadmin.com, garyrookard@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Chuong Ngo <cngo.linux@gmail.com>
Subject: [PATCH] drivers/staging/bcm: Added a space after a comma.
Date: Fri,  6 Jun 2014 13:55:20 -0400
Message-Id: <1402077320-13324-1-git-send-email-cngo.linux@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chuong Ngo <cngo.linux@gmail.com>
---
 drivers/staging/bcm/CmHost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index fb1d932..3dbdf0e 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1418,7 +1418,7 @@ static inline ULONG RestoreSFParam(struct bcm_mini_adapter *Adapter,
 	ulAddrSFParamSet = ntohl(ulAddrSFParamSet);
 
 	/* Read out the SF Param Set At the indicated Location */
-	if (rdm(Adapter, ulAddrSFParamSet,(PUCHAR)pucDestBuffer, nBytesToRead) < 0)
+	if (rdm(Adapter, ulAddrSFParamSet, (PUCHAR)pucDestBuffer, nBytesToRead) < 0)
 		return STATUS_FAILURE;
 
 	return 1;
-- 
2.0.0

