Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3JaPhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab3JaPhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:37:47 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <onestero@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/4][v2] audit: Kill the unused struct audit_aux_data_capset
Date: Thu, 31 Oct 2013 11:37:09 -0400
Message-Id: <81e50fc0974b009984976c307b32733bf50944b0.1383233534.git.rgb@redhat.com>
In-Reply-To: <cover.1383233533.git.rgb@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com>
In-Reply-To: <cover.1383233533.git.rgb@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
(cherry picked from commit 6904431d6b41190e42d6b94430b67cb4e7e6a4b7)
(cherry picked from commit 2b3a6c617396a9e6eedae9a56b2d9642da0216b6)
---
 kernel/auditsc.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 95293ab..24047f4 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -121,12 +121,6 @@ struct audit_aux_data_bprm_fcaps {
 	struct audit_cap_data	new_pcap;
 };
 
-struct audit_aux_data_capset {
-	struct audit_aux_data	d;
-	pid_t			pid;
-	struct audit_cap_data	cap;
-};
-
 struct audit_tree_refs {
 	struct audit_tree_refs *next;
 	struct audit_chunk *c[31];
-- 
1.7.1

