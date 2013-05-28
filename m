Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209Ab3E1Nch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:32:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122Ab3E1Nce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:32:34 -0400
Date: Tue, 28 May 2013 06:32:13 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-08825c90af6e4bb902b3a51abb0ae6530199f682@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, dzickus@redhat.com, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lizefan@huawei.com, dzickus@redhat.com
In-Reply-To: <51959678.6000802@huawei.com>
References: <51959678.6000802@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog: Document watchdog_thresh sysctl
Git-Commit-ID: 08825c90af6e4bb902b3a51abb0ae6530199f682
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

Commit-ID:  08825c90af6e4bb902b3a51abb0ae6530199f682
Gitweb:     http://git.kernel.org/tip/08825c90af6e4bb902b3a51abb0ae6530199f682
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 17 May 2013 10:31:20 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 11:28:19 +0200

watchdog: Document watchdog_thresh sysctl

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/51959678.6000802@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/sysctl/kernel.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index ccd4258..e8fabd6 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -76,6 +76,7 @@ show up in /proc/sys/kernel:
 - tainted
 - threads-max
 - unknown_nmi_panic
+- watchdog_thresh
 - version
 
 ==============================================================
@@ -648,3 +649,16 @@ that time, kernel debugging information is displayed on console.
 
 NMI switch that most IA32 servers have fires unknown NMI up, for
 example.  If a system hangs up, try pressing the NMI switch.
+
+==============================================================
+
+watchdog_thresh:
+
+This value can be used to control the frequency of hrtimer and NMI
+events and the soft and hard lockup thresholds. The default threshold
+is 10 seconds.
+
+The softlockup threshold is (2 * watchdog_thresh). Setting this
+tunable to zero will disable lockup detection altogether.
+
+==============================================================
