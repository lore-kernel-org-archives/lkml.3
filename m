Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3EQCb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:31:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62962 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab3EQCbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:31:55 -0400
Message-ID: <51959687.9090305@huawei.com>
Date: Fri, 17 May 2013 10:31:35 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] watchdog: Remove softlockup_thresh from Documentation
References: <51959668.9040106@huawei.com>
In-Reply-To: <51959668.9040106@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old softlockup detector has been replaced with new lockup
detector long ago.

Signed-off-by: Li Zefan <lizefan@huawei.com>
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
-- 
1.8.0.2
