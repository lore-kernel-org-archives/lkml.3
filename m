Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3HTVdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:33:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab3HTVdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:23 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 01/12] audit: Kill the unused struct audit_aux_data_capset
Date: Tue, 20 Aug 2013 17:31:53 -0400
Message-Id: <94daa1fc5ae78e01e13790a9d8f0f0fdff78068c.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
(cherry picked from commit 6904431d6b41190e42d6b94430b67cb4e7e6a4b7)
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9845cb3..8c644c5 100644
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

