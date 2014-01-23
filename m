Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaAWK57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:57:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbaAWK4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:56:47 -0500
From: Aaron Tomlin <atomlin@redhat.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mingo@redhat.com,
        oleg@redhat.com, riel@redhat.com, akpm@linux-foundation.org,
        atomlin@redhat.com
Subject: [RFC PATCH v5 1/2] sysctl: Make neg_one a standard constraint
Date: Thu, 23 Jan 2014 10:56:02 +0000
Message-Id: <1390474563-15424-2-git-send-email-atomlin@redhat.com>
In-Reply-To: <1390474563-15424-1-git-send-email-atomlin@redhat.com>
References: <1390474563-15424-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add neg_one to the list of standard constraints.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 kernel/sysctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a6047..dd531a6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -122,6 +122,7 @@ extern int blk_iopoll_enabled;
 static int sixty = 60;
 #endif
 
+static int neg_one = -1;
 static int zero;
 static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
-- 
1.8.4.2

