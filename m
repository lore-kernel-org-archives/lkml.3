Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbaGAT4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:56:06 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36699 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbaGAT4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:56:03 -0400
From: Matt Kurz <matt@ninezulu.com>
To: gregkh@linuxfoundation.org
Cc: Matt Kurz <matt@ninezulu.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wlan-ng/prism2fw.c: Add blank line after declarations
Date: Wed,  2 Jul 2014 05:59:54 +1000
Message-Id: <1404244794-15696-1-git-send-email-matt@ninezulu.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl warnings due to missing blank line after declarations

Signed-off-by: Matt Kurz <matt@ninezulu.com>
---
 drivers/staging/wlan-ng/prism2fw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index f787035..42c14b0 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -445,6 +445,7 @@ static int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
 static void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks)
 {
 	int i;
+
 	for (i = 0; i < *nfchunks; i++)
 		kfree(fchunk[i].data);
 
@@ -1060,6 +1061,7 @@ static int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 		for (j = 0; j < nwrites; j++) {
 			/* TODO Move this to a separate function */
 			int lenleft = fchunk[i].len - (WRITESIZE_MAX * j);
+
 			if (fchunk[i].len > WRITESIZE_MAX)
 				currlen = WRITESIZE_MAX;
 			else
-- 
2.0.1

