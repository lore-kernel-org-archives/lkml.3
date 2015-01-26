Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbbAZJYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:24:41 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:64097 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbAZJYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:24:39 -0500
Date: Mon, 26 Jan 2015 11:24:36 +0200
From: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
To: devel@driverdev.osuosl.org
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        gclement@baobob.org, guido@vanguardiasur.com.ar,
        veronicca114@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: vt6655: fix that open brace { should be on the
 previous line
Message-ID: <20150126092436.GA3622@mariam-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
fix that open brace { should be on the previous line

Signed-off-by: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
---
v2: Adjusted my legal name.

 drivers/staging/vt6655/card.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 47801ca..1cdcf49 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -68,8 +68,8 @@
 
 /*---------------------  Static Variables  --------------------------*/
 
-static const unsigned short cwRXBCNTSFOff[MAX_RATE] =
-{17, 17, 17, 17, 34, 23, 17, 11, 8, 5, 4, 3};
+static const unsigned short cwRXBCNTSFOff[MAX_RATE] = {
+	17, 17, 17, 17, 34, 23, 17, 11, 8, 5, 4, 3};
 
 /*---------------------  Static Functions  --------------------------*/
 
-- 
1.9.1

