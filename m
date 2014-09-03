Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbaICLUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:20:35 -0400
Received: from syn.loicp.eu ([176.31.96.212]:44660 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbaICLU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:20:29 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 07:20:29 EDT
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] staging: goldfish: suppress consecutive blank lines
Date: Wed,  3 Sep 2014 13:13:42 +0200
Message-Id: <1409742827-6048-2-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409742827-6048-1-git-send-email-loic@loicp.eu>
References: <1409742827-6048-1-git-send-email-loic@loicp.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style: suppress consecutive blank lines

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/goldfish/goldfish_audio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index c89d0b8..23a206d 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -108,10 +108,8 @@ enum {
 					  AUDIO_INT_READ_BUFFER_FULL,
 };
 
-
 static atomic_t open_count = ATOMIC_INIT(0);
 
-
 static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
 						size_t count, loff_t *pos)
 {
-- 
2.0.4

