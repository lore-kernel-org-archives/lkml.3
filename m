Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaDYRhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:37:08 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:55360 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaDYRhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:37:06 -0400
From: Nicolas Del Piano <ndel314@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nicolas Del Piano <ndel314@gmail.com>
Subject: [PATCH] Staging: vt6655: tether: fixed a brace coding style issue
Date: Fri, 25 Apr 2014 14:36:56 -0300
Message-Id: <1398447416-12101-1-git-send-email-ndel314@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
---
 drivers/staging/vt6655/tether.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/tether.c b/drivers/staging/vt6655/tether.c
index a5dc3c09..1e7d3e2 100644
--- a/drivers/staging/vt6655/tether.c
+++ b/drivers/staging/vt6655/tether.c
@@ -98,8 +98,8 @@ bool ETHbIsBufferCrc32Ok(unsigned char *pbyBuffer, unsigned int cbFrameLength)
 	unsigned long dwCRC;
 
 	dwCRC = CRCdwGetCrc32(pbyBuffer, cbFrameLength - 4);
-	if (cpu_to_le32(*((unsigned long *)(pbyBuffer + cbFrameLength - 4))) != dwCRC) {
+	if (cpu_to_le32(*((unsigned long *)(pbyBuffer + cbFrameLength - 4))) != dwCRC)
 		return false;
-	}
+
 	return true;
 }
-- 
1.7.9.5

