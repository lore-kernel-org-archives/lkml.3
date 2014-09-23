Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaIWTFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:05:36 -0400
Received: from mail-oi0-f74.google.com ([209.85.218.74]:62047 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbaIWTF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:05:26 -0400
From: Peter Feiner <pfeiner@google.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: [PATCH 1/3] tools: add .gitignore entries for selftests
Date: Tue, 23 Sep 2014 12:05:21 -0700
Message-Id: <1411499123-18050-1-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1411499027-17801-1-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Feiner <pfeiner@google.com>
---
 tools/testing/selftests/breakpoints/.gitignore | 1 +
 tools/testing/selftests/efivarfs/.gitignore    | 2 ++
 tools/testing/selftests/ptrace/.gitignore      | 1 +
 tools/testing/selftests/timers/.gitignore      | 1 +
 tools/testing/selftests/vm/.gitignore          | 9 +++++----
 5 files changed, 10 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/efivarfs/.gitignore
 create mode 100644 tools/testing/selftests/ptrace/.gitignore
 create mode 100644 tools/testing/selftests/timers/.gitignore

diff --git a/tools/testing/selftests/breakpoints/.gitignore b/tools/testing/selftests/breakpoints/.gitignore
new file mode 100644
index 0000000..ad66922
--- /dev/null
+++ b/tools/testing/selftests/breakpoints/.gitignore
@@ -0,0 +1 @@
+/breakpoint_test
diff --git a/tools/testing/selftests/efivarfs/.gitignore b/tools/testing/selftests/efivarfs/.gitignore
new file mode 100644
index 0000000..66c6e85
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/.gitignore
@@ -0,0 +1,2 @@
+/create-read
+/open-unlink
diff --git a/tools/testing/selftests/ptrace/.gitignore b/tools/testing/selftests/ptrace/.gitignore
new file mode 100644
index 0000000..d348b86
--- /dev/null
+++ b/tools/testing/selftests/ptrace/.gitignore
@@ -0,0 +1 @@
+/peeksiginfo
diff --git a/tools/testing/selftests/timers/.gitignore b/tools/testing/selftests/timers/.gitignore
new file mode 100644
index 0000000..ac85e5b
--- /dev/null
+++ b/tools/testing/selftests/timers/.gitignore
@@ -0,0 +1 @@
+/posix_timers
diff --git a/tools/testing/selftests/vm/.gitignore b/tools/testing/selftests/vm/.gitignore
index ff1bb16..e57961f 100644
--- a/tools/testing/selftests/vm/.gitignore
+++ b/tools/testing/selftests/vm/.gitignore
@@ -1,4 +1,5 @@
-hugepage-mmap
-hugepage-shm
-map_hugetlb
-thuge-gen
+/hugepage-mmap
+/hugepage-shm
+/map_hugetlb
+/thuge-gen
+/hugetlbfstest
-- 
2.1.0.rc2.206.gedb03e5

