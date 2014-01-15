Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaAOQ2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:28:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbaAOQ1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:27:54 -0500
From: atomlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, oleg@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org
Subject: [RFC PATCH v3 1/2] sysctl: Make neg_one a standard constraint
Date: Wed, 15 Jan 2014 16:27:10 +0000
Message-Id: <1389803231-16092-2-git-send-email-atomlin@redhat.com>
In-Reply-To: <1389803231-16092-1-git-send-email-atomlin@redhat.com>
References: <1389803231-16092-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

Add neg_one to the list of standard constraints.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
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

