Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3EQCbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:31:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62599 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3EQCbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:31:35 -0400
Message-ID: <51959678.6000802@huawei.com>
Date: Fri, 17 May 2013 10:31:20 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] watchdog: Document watchdog_thresh sysctl
References: <51959668.9040106@huawei.com>
In-Reply-To: <51959668.9040106@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizefan@huawei.com>
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
-- 
1.8.0.2
