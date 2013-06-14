Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab3FNCnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:43:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46644 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932452Ab3FNCnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:43:08 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 33/33] security: keys: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:58 -0700
Message-Id: <ad66668444b208b02c100cbcd67d97a113419cbc.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/keys/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
index ee32d18..9a9df6f 100644
--- a/security/keys/sysctl.c
+++ b/security/keys/sysctl.c
@@ -15,7 +15,7 @@
 
 static const int zero, one = 1, max = INT_MAX;
 
-ctl_table key_sysctls[] = {
+struct ctl_table key_sysctls[] = {
 	{
 		.procname = "maxkeys",
 		.data = &key_quota_maxkeys,
-- 
1.8.1.2.459.gbcd45b4.dirty

