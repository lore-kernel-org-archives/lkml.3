Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaBLCR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:17:26 -0500
Received: from mail-pd0-f196.google.com ([209.85.192.196]:52124 "EHLO
	mail-pd0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaBLCRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:17:01 -0500
From: chishanmingshen <chishanmingshen@gmail.com>
To: chishanmingshen <chishanmingshen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] init:Fix comment error
Date: Wed, 12 Feb 2014 10:16:30 +0800
Message-Id: <1392171390-4826-1-git-send-email-chishanmingshen@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix comment error

Signed-off-by: chishanmingshen <chishanmingshen@gmail.com>
---
 init/do_mounts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 8e5addc..82f2288 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -102,13 +102,13 @@ no_match:
 
 /**
  * devt_from_partuuid - looks up the dev_t of a partition by its UUID
- * @uuid:	char array containing ascii UUID
+ * @uuid_str:	char array containing ascii UUID
  *
  * The function will return the first partition which contains a matching
  * UUID value in its partition_meta_info struct.  This does not search
  * by filesystem UUIDs.
  *
- * If @uuid is followed by a "/PARTNROFF=%d", then the number will be
+ * If @uuid_str is followed by a "/PARTNROFF=%d", then the number will be
  * extracted and used as an offset from the partition identified by the UUID.
  *
  * Returns the matching dev_t on success or 0 on failure.
-- 
1.7.9.5

