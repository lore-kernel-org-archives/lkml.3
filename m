Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab3E1Ndv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:33:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122Ab3E1Ndt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:33:49 -0400
Date: Tue, 28 May 2013 06:33:29 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-c0ffaf3655fab1909a920c8f30ba1722932d01bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, dzickus@redhat.com, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lizefan@huawei.com, dzickus@redhat.com
In-Reply-To: <51959687.9090305@huawei.com>
References: <51959687.9090305@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog:
  Remove softlockup_thresh from Documentation
Git-Commit-ID: c0ffaf3655fab1909a920c8f30ba1722932d01bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0ffaf3655fab1909a920c8f30ba1722932d01bb
Gitweb:     http://git.kernel.org/tip/c0ffaf3655fab1909a920c8f30ba1722932d01bb
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 17 May 2013 10:31:35 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 11:28:20 +0200

watchdog: Remove softlockup_thresh from Documentation

The old softlockup detector has been replaced with new lockup
detector long ago.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/51959687.9090305@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/sysctl/kernel.txt | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index e8fabd6..bcff3f9 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -70,7 +70,6 @@ show up in /proc/sys/kernel:
 - shmall
 - shmmax                      [ sysv ipc ]
 - shmmni
-- softlockup_thresh
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
 - tainted
@@ -605,15 +604,6 @@ without users and with a dead originative process will be destroyed.
 
 ==============================================================
 
-softlockup_thresh:
-
-This value can be used to lower the softlockup tolerance threshold.  The
-default threshold is 60 seconds.  If a cpu is locked up for 60 seconds,
-the kernel complains.  Valid values are 1-60 seconds.  Setting this
-tunable to zero will disable the softlockup detection altogether.
-
-==============================================================
-
 tainted:
 
 Non-zero if the kernel has been tainted.  Numeric values, which
