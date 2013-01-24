Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3AXUE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:04:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab3AXUES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:04:18 -0500
Date: Thu, 24 Jan 2013 12:03:57 -0800
From: tip-bot for Yuanhan Liu <yuanhan.liu@linux.intel.com>
Message-ID: <tip-5b43715b9d27e4e6620264113169bb8e4e607205@git.kernel.org>
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
Git-Commit-ID: 5b43715b9d27e4e6620264113169bb8e4e607205
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:04:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b43715b9d27e4e6620264113169bb8e4e607205
Gitweb:     http://git.kernel.org/tip/5b43715b9d27e4e6620264113169bb8e4e607205
Author:     Yuanhan Liu <yuanhan.liu@linux.intel.com>
AuthorDate: Thu, 24 Jan 2013 17:22:44 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 10:59:43 +0100

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
 
