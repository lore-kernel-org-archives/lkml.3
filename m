Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaIHWzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:55:13 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:47589 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaIHWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:55:10 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        linux-doc@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH 1/2] [PATCH] Documentation: update .gitignore files
Date: Mon,  8 Sep 2014 18:54:59 -0400
Message-Id: <1410216900-22390-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some missing files to .gitignore.
Push Documentation/.gitignore down into subdirectories.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Documentation/.gitignore                         | 7 -------
 Documentation/arm/SH-Mobile/.gitignore           | 1 +
 Documentation/filesystems/.gitignore             | 1 +
 Documentation/laptops/.gitignore                 | 2 ++
 Documentation/networking/.gitignore              | 0
 Documentation/networking/timestamping/.gitignore | 1 +
 Documentation/prctl/.gitignore                   | 3 +++
 Documentation/ptp/.gitignore                     | 1 +
 Documentation/timers/.gitignore                  | 1 +
 Documentation/vDSO/.gitignore                    | 2 ++
 Documentation/video4linux/.gitignore             | 1 -
 11 files changed, 12 insertions(+), 8 deletions(-)
 delete mode 100644 Documentation/.gitignore
 create mode 100644 Documentation/arm/SH-Mobile/.gitignore
 create mode 100644 Documentation/filesystems/.gitignore
 create mode 100644 Documentation/laptops/.gitignore
 delete mode 100644 Documentation/networking/.gitignore
 create mode 100644 Documentation/prctl/.gitignore
 create mode 100644 Documentation/ptp/.gitignore
 create mode 100644 Documentation/timers/.gitignore
 create mode 100644 Documentation/vDSO/.gitignore
 delete mode 100644 Documentation/video4linux/.gitignore

diff --git a/Documentation/.gitignore b/Documentation/.gitignore
deleted file mode 100644
index bcd907b..0000000
--- a/Documentation/.gitignore
+++ /dev/null
@@ -1,7 +0,0 @@
-filesystems/dnotify_test
-laptops/dslm
-timers/hpet_example
-vm/hugepage-mmap
-vm/hugepage-shm
-vm/map_hugetlb
-
diff --git a/Documentation/arm/SH-Mobile/.gitignore b/Documentation/arm/SH-Mobile/.gitignore
new file mode 100644
index 0000000..c928dbf
--- /dev/null
+++ b/Documentation/arm/SH-Mobile/.gitignore
@@ -0,0 +1 @@
+vrl4
diff --git a/Documentation/filesystems/.gitignore b/Documentation/filesystems/.gitignore
new file mode 100644
index 0000000..31d6e42
--- /dev/null
+++ b/Documentation/filesystems/.gitignore
@@ -0,0 +1 @@
+dnotify_test
diff --git a/Documentation/laptops/.gitignore b/Documentation/laptops/.gitignore
new file mode 100644
index 0000000..da2bd06
--- /dev/null
+++ b/Documentation/laptops/.gitignore
@@ -0,0 +1,2 @@
+dslm
+freefall
diff --git a/Documentation/networking/.gitignore b/Documentation/networking/.gitignore
deleted file mode 100644
index e69de29..0000000
diff --git a/Documentation/networking/timestamping/.gitignore b/Documentation/networking/timestamping/.gitignore
index a380159..9e69e98 100644
--- a/Documentation/networking/timestamping/.gitignore
+++ b/Documentation/networking/timestamping/.gitignore
@@ -1,2 +1,3 @@
 timestamping
+txtimestamp
 hwtstamp_config
diff --git a/Documentation/prctl/.gitignore b/Documentation/prctl/.gitignore
new file mode 100644
index 0000000..0b5c274
--- /dev/null
+++ b/Documentation/prctl/.gitignore
@@ -0,0 +1,3 @@
+disable-tsc-ctxt-sw-stress-test
+disable-tsc-on-off-stress-test
+disable-tsc-test
diff --git a/Documentation/ptp/.gitignore b/Documentation/ptp/.gitignore
new file mode 100644
index 0000000..f562e49
--- /dev/null
+++ b/Documentation/ptp/.gitignore
@@ -0,0 +1 @@
+testptp
diff --git a/Documentation/timers/.gitignore b/Documentation/timers/.gitignore
new file mode 100644
index 0000000..c5c45d7
--- /dev/null
+++ b/Documentation/timers/.gitignore
@@ -0,0 +1 @@
+hpet_example
diff --git a/Documentation/vDSO/.gitignore b/Documentation/vDSO/.gitignore
new file mode 100644
index 0000000..133bf9e
--- /dev/null
+++ b/Documentation/vDSO/.gitignore
@@ -0,0 +1,2 @@
+vdso_test
+vdso_standalone_test_x86
diff --git a/Documentation/video4linux/.gitignore b/Documentation/video4linux/.gitignore
deleted file mode 100644
index 9527039..0000000
--- a/Documentation/video4linux/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-v4lgrab
-- 
2.1.0

