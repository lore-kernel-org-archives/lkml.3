Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaAaIqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:46:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41339 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaAaIqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:46:00 -0500
Date: Fri, 31 Jan 2014 00:45:33 -0800
From: tip-bot for Aaron Tomlin <tipbot@zytor.com>
Message-ID: <tip-70e0ac5f3683f48a8174a6f231a0f3097217c189@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        atomlin@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, atomlin@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] hung_task/Documentation:
  Fix hung_task_warnings description
Git-Commit-ID: 70e0ac5f3683f48a8174a6f231a0f3097217c189
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 31 Jan 2014 00:45:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70e0ac5f3683f48a8174a6f231a0f3097217c189
Gitweb:     http://git.kernel.org/tip/70e0ac5f3683f48a8174a6f231a0f3097217c189
Author:     Aaron Tomlin <atomlin@redhat.com>
AuthorDate: Mon, 27 Jan 2014 09:00:57 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 31 Jan 2014 09:24:03 +0100

hung_task/Documentation: Fix hung_task_warnings description

Improve the documentation on hung_task_warnings.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Link: http://lkml.kernel.org/n/tip-xepjnxzummfDlg9lvhh7Rlzc@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/sysctl/kernel.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 4205f3c..621c56c 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -319,10 +319,11 @@ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 ==============================================================
 
-hung_task_warning:
+hung_task_warnings:
 
 The maximum number of warnings to report. During a check interval
-When this value is reached, no more the warnings will be reported.
+if a hung task is detected, this value is decreased by 1.
+When this value reaches 0, no more warnings will be reported.
 This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 -1: report an infinite number of warnings.
