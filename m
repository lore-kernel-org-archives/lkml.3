Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaLTM31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:29:27 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44268 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaLTM3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:29:24 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] security: selinux: avc.c:  Remove unused function
Date: Sat, 20 Dec 2014 13:32:10 +0100
Message-Id: <1419078730-31316-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function avc_sidcmp() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 security/selinux/avc.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index a18f1fa..afcc0ae 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -517,11 +517,6 @@ out:
 	return rc;
 }
 
-static inline int avc_sidcmp(u32 x, u32 y)
-{
-	return (x == y || x == SECSID_WILD || y == SECSID_WILD);
-}
-
 /**
  * avc_update_node Update an AVC entry
  * @event : Updating event
-- 
1.7.10.4

