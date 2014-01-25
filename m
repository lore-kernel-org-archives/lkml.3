Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaAYOZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:25:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaAYOY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:24:56 -0500
Date: Sat, 25 Jan 2014 06:24:39 -0800
From: tip-bot for Aaron Tomlin <tipbot@zytor.com>
Message-ID: <tip-2397efb1bb17595b35f31abb40d95074ebc04f1b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, atomlin@redhat.com, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, atomlin@redhat.com,
        rientjes@google.com
In-Reply-To: <1390239253-24030-2-git-send-email-atomlin@redhat.com>
References: <1390239253-24030-2-git-send-email-atomlin@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] sysctl: Add neg_one as a standard constraint
Git-Commit-ID: 2397efb1bb17595b35f31abb40d95074ebc04f1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:24:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2397efb1bb17595b35f31abb40d95074ebc04f1b
Gitweb:     http://git.kernel.org/tip/2397efb1bb17595b35f31abb40d95074ebc04f1b
Author:     Aaron Tomlin <atomlin@redhat.com>
AuthorDate: Mon, 20 Jan 2014 17:34:12 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 08:59:53 +0100

sysctl: Add neg_one as a standard constraint

Add neg_one to the list of standard constraints - will be used by the next patch.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: oleg@redhat.com
Link: http://lkml.kernel.org/r/1390239253-24030-2-git-send-email-atomlin@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sysctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c8da99f..c398a58 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -122,6 +122,7 @@ extern int blk_iopoll_enabled;
 static int sixty = 60;
 #endif
 
+static int neg_one = -1;
 static int zero;
 static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
