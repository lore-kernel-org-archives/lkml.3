Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab3IRDpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 23:45:24 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27344 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3IRDpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 23:45:23 -0400
Message-ID: <523921BD.3030205@huawei.com>
Date: Wed, 18 Sep 2013 11:45:01 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <rob@landley.net>, <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] doc: fix some typos in documentations
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos in five documentations, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/md.txt              |    2 +-
 Documentation/rfkill.txt          |    2 +-
 Documentation/rt-mutex-design.txt |    2 +-
 Documentation/static-keys.txt     |    4 ++--
 Documentation/sysfs-rules.txt     |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index fbb2fcb..f925666 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -533,7 +533,7 @@ also have
       found.  The count in 'mismatch_cnt' is the number of sectors
       that were re-written, or (for 'check') would have been
       re-written.  As most raid levels work in units of pages rather
-      than sectors, this my be larger than the number of actual errors
+      than sectors, this may be larger than the number of actual errors
       by a factor of the number of sectors in a page.
 
    bitmap_set_bits
diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index 03c9d92..f430004 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -71,7 +71,7 @@ To create an rfkill driver, driver's Kconfig needs to have
 	depends on RFKILL || !RFKILL
 
 to ensure the driver cannot be built-in when rfkill is modular. The !RFKILL
-case allows the driver to be built when rfkill is not configured, which which
+case allows the driver to be built when rfkill is not configured, which
 case all rfkill API can still be used but will be provided by static inlines
 which compile to almost nothing.
 
diff --git a/Documentation/rt-mutex-design.txt b/Documentation/rt-mutex-design.txt
index a5bcd7f..8666070 100644
--- a/Documentation/rt-mutex-design.txt
+++ b/Documentation/rt-mutex-design.txt
@@ -30,7 +30,7 @@ is something called unbounded priority inversion.  That is when the high
 priority process is prevented from running by a lower priority process for
 an undetermined amount of time.
 
-The classic example of unbounded priority inversion is were you have three
+The classic example of unbounded priority inversion is where you have three
 processes, let's call them processes A, B, and C, where A is the highest
 priority process, C is the lowest, and B is in between. A tries to grab a lock
 that C owns and must wait and lets C run to release the lock. But in the
diff --git a/Documentation/static-keys.txt b/Documentation/static-keys.txt
index 9f5263d..c4407a4 100644
--- a/Documentation/static-keys.txt
+++ b/Documentation/static-keys.txt
@@ -116,7 +116,7 @@ The branch(es) can then be switched via:
 	static_key_slow_dec(&key);
 
 Thus, 'static_key_slow_inc()' means 'make the branch true', and
-'static_key_slow_dec()' means 'make the the branch false' with appropriate
+'static_key_slow_dec()' means 'make the branch false' with appropriate
 reference counting. For example, if the key is initialized true, a
 static_key_slow_dec(), will switch the branch to false. And a subsequent
 static_key_slow_inc(), will change the branch back to true. Likewise, if the
@@ -236,7 +236,7 @@ label case adds:
 
 If we then include the padding bytes, the jump label code saves, 16 total bytes
 of instruction memory for this small function. In this case the non-jump label
-function is 80 bytes long. Thus, we have have saved 20% of the instruction
+function is 80 bytes long. Thus, we have saved 20% of the instruction
 footprint. We can in fact improve this even further, since the 5-byte no-op
 really can be a 2-byte no-op since we can reach the branch with a 2-byte jmp.
 However, we have not yet implemented optimal no-op sizes (they are currently
diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
index c1a1fd6..a5f985e 100644
--- a/Documentation/sysfs-rules.txt
+++ b/Documentation/sysfs-rules.txt
@@ -47,7 +47,7 @@ versions of the sysfs interface.
         at device creation and removal
       - the unique key to the device at that point in time
       - the kernel's path to the device directory without the leading
-        /sys, and always starting with with a slash
+        /sys, and always starting with a slash
       - all elements of a devpath must be real directories. Symlinks
         pointing to /sys/devices must always be resolved to their real
         target and the target path must be used to access the device.
-- 
1.7.1


