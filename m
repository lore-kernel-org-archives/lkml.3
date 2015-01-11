Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbbAKSoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 13:44:10 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:35605 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbAKSoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 13:44:06 -0500
Date: Sun, 11 Jan 2015 13:44:03 -0500
From: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
To: andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: HPDD-discuss@ml01.01.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: lustre: Fix spacing error in libcfs_string.c
Message-ID: <20150111184403.GA17805@Caladan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error in libcfs_string.c:

ERROR: spaces required around that '='

Signed-off-by: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/libcfs_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
index fb88733..e67a18d 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
@@ -132,7 +132,7 @@ char *cfs_firststr(char *str, size_t size)
 		++end;
 	}
 
-	*end= '\0';
+	*end = '\0';
 out:
 	return str;
 }
-- 
1.9.1

