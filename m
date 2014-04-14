Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaDNB5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:57:05 -0400
Received: from smtprelay0001.hostedemail.com ([216.40.44.1]:51195 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754764AbaDNB4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:56:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1538:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:2894:3138:3139:3140:3141:3142:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: juice54_58dfdae5a5508
X-Filterd-Recvd-Size: 1466
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next 3.16 19/19] security: Convert use of typedef ctl_table to struct ctl_table
Date: Sun, 13 Apr 2014 18:55:51 -0700
Message-Id: <4104b157fcc0867b2348c364556a5a44da2a0324.1397438826.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1397438826.git.joe@perches.com>
References: <cover.1397438826.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/keys/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
index 8c0af08..b68faa1 100644
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

