Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbbAMXuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:50:17 -0500
Received: from ozlabs.org ([103.22.144.67]:36354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbbAMXuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:50:15 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linuxppc-dev@ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>, shuahkh@osg.samsung.com
Subject: [PATCH] selftests/powerpc: Add .gitignore for powerpc selftests
Date: Wed, 14 Jan 2015 10:49:57 +1100
Message-Id: <1421192997-17003-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 .../testing/selftests/powerpc/copyloops/.gitignore |  4 ++++
 tools/testing/selftests/powerpc/mm/.gitignore      |  1 +
 tools/testing/selftests/powerpc/pmu/.gitignore     |  3 +++
 tools/testing/selftests/powerpc/pmu/ebb/.gitignore | 22 ++++++++++++++++++++++
 .../selftests/powerpc/primitives/.gitignore        |  1 +
 tools/testing/selftests/powerpc/tm/.gitignore      |  1 +
 6 files changed, 32 insertions(+)
 create mode 100644 tools/testing/selftests/powerpc/copyloops/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/mm/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/pmu/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/primitives/.gitignore
 create mode 100644 tools/testing/selftests/powerpc/tm/.gitignore

diff --git a/tools/testing/selftests/powerpc/copyloops/.gitignore b/tools/testing/selftests/powerpc/copyloops/.gitignore
new file mode 100644
index 000000000000..25a192f62c4d
--- /dev/null
+++ b/tools/testing/selftests/powerpc/copyloops/.gitignore
@@ -0,0 +1,4 @@
+copyuser_64
+copyuser_power7
+memcpy_64
+memcpy_power7
diff --git a/tools/testing/selftests/powerpc/mm/.gitignore b/tools/testing/selftests/powerpc/mm/.gitignore
new file mode 100644
index 000000000000..156f4e89c2f1
--- /dev/null
+++ b/tools/testing/selftests/powerpc/mm/.gitignore
@@ -0,0 +1 @@
+hugetlb_vs_thp_test
diff --git a/tools/testing/selftests/powerpc/pmu/.gitignore b/tools/testing/selftests/powerpc/pmu/.gitignore
new file mode 100644
index 000000000000..e748f336eed3
--- /dev/null
+++ b/tools/testing/selftests/powerpc/pmu/.gitignore
@@ -0,0 +1,3 @@
+count_instructions
+l3_bank_test
+per_event_excludes
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/.gitignore b/tools/testing/selftests/powerpc/pmu/ebb/.gitignore
new file mode 100644
index 000000000000..5967ff34c167
--- /dev/null
+++ b/tools/testing/selftests/powerpc/pmu/ebb/.gitignore
@@ -0,0 +1,22 @@
+back_to_back_ebbs_test
+close_clears_pmcc_test
+cpu_event_pinned_vs_ebb_test
+cpu_event_vs_ebb_test
+cycles_test
+cycles_with_freeze_test
+cycles_with_mmcr2_test
+ebb_on_child_test
+ebb_on_willing_child_test
+ebb_vs_cpu_event_test
+event_attributes_test
+fork_cleanup_test
+instruction_count_test
+lost_exception_test
+multi_counter_test
+multi_ebb_procs_test
+no_handler_test
+pmae_handling_test
+pmc56_overflow_test
+reg_access_test
+task_event_pinned_vs_ebb_test
+task_event_vs_ebb_test
diff --git a/tools/testing/selftests/powerpc/primitives/.gitignore b/tools/testing/selftests/powerpc/primitives/.gitignore
new file mode 100644
index 000000000000..4cc4e31bed1d
--- /dev/null
+++ b/tools/testing/selftests/powerpc/primitives/.gitignore
@@ -0,0 +1 @@
+load_unaligned_zeropad
diff --git a/tools/testing/selftests/powerpc/tm/.gitignore b/tools/testing/selftests/powerpc/tm/.gitignore
new file mode 100644
index 000000000000..33d02cc54a3e
--- /dev/null
+++ b/tools/testing/selftests/powerpc/tm/.gitignore
@@ -0,0 +1 @@
+tm-resched-dscr
-- 
2.1.0

