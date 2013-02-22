Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab3BVMWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:22:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3BVMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:22:14 -0500
Date: Fri, 22 Feb 2013 04:20:48 -0800
From: tip-bot for Yuanhan Liu <tipbot@zytor.com>
Message-ID: <tip-0be5c8ff58cf7a66019af2f1236daff731ed318c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yuanhan.liu@linux.intel.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yuanhan.liu@linux.intel.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/stat: Fix a typo
Git-Commit-ID: 0be5c8ff58cf7a66019af2f1236daff731ed318c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 22 Feb 2013 04:20:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0be5c8ff58cf7a66019af2f1236daff731ed318c
Gitweb:     http://git.kernel.org/tip/0be5c8ff58cf7a66019af2f1236daff731ed318c
Author:     Yuanhan Liu <yuanhan.liu@linux.intel.com>
AuthorDate: Thu, 24 Jan 2013 17:22:44 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Feb 2013 08:42:37 +0100

locking/stat: Fix a typo

s/STATS/STAT

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/lockstat.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index cef00d4..dd2f7b2 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -65,7 +65,7 @@ that had to wait on lock acquisition.
 
  - CONFIGURATION
 
-Lock statistics are enabled via CONFIG_LOCK_STATS.
+Lock statistics are enabled via CONFIG_LOCK_STAT.
 
  - USAGE
 
