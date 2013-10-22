Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3JVWbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:31:37 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:42942 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755835Ab3JVWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:31:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1538:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:2894:3138:3139:3140:3141:3142:3868:3871:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cream24_d4b3cffc7013
X-Filterd-Recvd-Size: 1415
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 24/24] security:keys: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:30:07 -0700
Message-Id: <3cbf6b738eccd1bb9c153e2b9dd7ea8fa89eb48b.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
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

