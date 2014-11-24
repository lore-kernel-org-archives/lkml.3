Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaKXGRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:17:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24585 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaKXGRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:17:01 -0500
X-AuditID: cbfee68e-f79b46d000002b74-fd-5472cd5a791b
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v6 7/10] xfstests: generic/040: Multi insert range tests
Date: Mon, 24 Nov 2014 15:16:58 +0900
Message-id: <003001d007ae$40a985e0$c1fc91a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAHrWlDd02mItFvT7OM72yMz49CTA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkQDfqbFGIwYaVZhZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoErY/8TkYJOzYrniyUaGDuVuhg5OSQETCR+rHjABGGLSVy4t56ti5GL
	Q0hgKaPEmik9rF2MHGBFS95GQcSnM0o8u7SYEcL5yyjxcf0jsCI2AW2JP1tEQQaJCLhKzLv7
	HayGGWTQxcdPGEESwgIeEhd3bGYDsVkEVCWePFzECmLzClhKtBxfB2ULSvyYfI8FxGYW0JJY
	v/M4E4QtL7F5zVtmiEsVJHacfc0IsUxP4uXUV6wQNSIS+168A1ssIXCOXWLWqgmsEMsEJL5N
	PsQC8Y2sxKYDUHMkJQ6uuMEygVFsFpLVs5CsnoVk9SwkKxYwsqxiFE0tSC4oTkovMtIrTswt
	Ls1L10vOz93ECIzE0/+e9e1gvHnA+hCjAAejEg/vh41FIUKsiWXFlbmHGE2BLprILCWanA+M
	97ySeENjMyMLUxNTYyNzSzMlcd4EqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgNNmgZ
	qn2ven0t3zHH2zFGz992yqPqpk8WhW85hC+fl/0t8nfupC8R8+psLnjtfS8huGdnZugZHdbV
	WuXTz6YEX1bW6JP6VSbuUNl1cG5qaGvXQtH8AOUe/pl//j7ZJLJHjDW+NFlH+OJTwaZ0zj/c
	OaV/DHskSi+qnJ4tEj9TZqq/0PVwQSWW4oxEQy3mouJEAKXzKTW/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jQd2os0UhBjdf6losnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBn7n4gUdGpWPF8s0cDYqdTF
	yMEhIWAiseRtVBcjJ5ApJnHh3nq2LkYuDiGB6YwSzy4tZoRw/jJKfFz/iBWkgU1AW+LPFlGQ
	BhEBV4l5d7+D1TALLGWUuPj4CSNIQljAQ+Lijs1sIDaLgKrEk4eLWEFsXgFLiZbj66BsQYkf
	k++xgNjMAloS63ceZ4Kw5SU2r3nLDHGRgsSOs68ZIZbpSbyc+ooVokZEYt+Ld4wTGAVmIRk1
	C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcJw/k9rBuLLB4hCjAAej
	Eg/vh41FIUKsiWXFlbmHGCU4mJVEeM/+KwwR4k1JrKxKLcqPLyrNSS0+xGgK9OlEZinR5Hxg
	CsoriTc0NjEzsjQyN7QwMjZXEue9cTM3REggPbEkNTs1tSC1CKaPiYNTqoFxSfwlZ6dbdafu
	FC5NbzF68qpN4ov+rxB/y5mm+XeDN6QsSwiKjy380C23pL3yRFpey7bKf28fh1jUm0eFxWRt
	PZyXu90/tzsk/fXTbaeY7p4/WMftHyJ7vPphpORRRcO3QSzKHze9V/pxU8B9A3eaf1z2Gyet
	VqnfuUH/T858usVBKj6cQ1OJpTgj0VCLuag4EQBVAKZfCQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(040) tries to test various corner cases with pre-existing holes
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/040     | 65 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/040.out | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 146 insertions(+)
 create mode 100644 tests/generic/040
 create mode 100644 tests/generic/040.out

diff --git a/tests/generic/040 b/tests/generic/040
new file mode 100644
index 0000000..df1c92f
--- /dev/null
+++ b/tests/generic/040
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/040
+#
+# Multi insert range tests
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for finsert range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+# we need to include common/punch to get defination fo filter functions
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "finsert"
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch -k falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/040.out b/tests/generic/040.out
new file mode 100644
index 0000000..c901e10
--- /dev/null
+++ b/tests/generic/040.out
@@ -0,0 +1,80 @@
+QA output created by 040
+	1. into a hole
+cf845a781c107ec1346e849c9dd1b7e8
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..55]: extent
+64e72217eebcbdf31b1b058f9f5f476a
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..55]: extent
+22b7303d274481990b5401b6263effe0
+	4. hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..55]: extent
+c4fef62ba1de9d91a977cfeec6632f19
+	5. hole -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..55]: extent
+1ca74f7572a0f4ab477fdbb5682e5f61
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..47]: hole
+4: [48..55]: extent
+be0f35d4292a20040766d87883b0abd1
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+bddb1f3895268acce30d516a99cb0f2f
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+4: [40..55]: extent
+f8fc47adc45b7cf72f988b3ddf5bff64
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+c4fef62ba1de9d91a977cfeec6632f19
+	10. hole -> data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+2: [40..63]: extent
+52af1bfcbf43f28af2328de32e0567e5
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+3: [40..47]: hole
+4: [48..63]: extent
+e3a8d52acc4d91a8ed19d7b6f4f26a71
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..63]: extent
+52af1bfcbf43f28af2328de32e0567e5
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..63]: extent
+2b22165f4a24a2c36fd05ef00b41df88
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+2: [40..55]: extent
+aa0f20d1edcdbce60d8ef82700ba30c3
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..55]: extent
+86c9d033be2761385c9cfa203c426bb2
diff --git a/tests/generic/group b/tests/generic/group
index 4beb27f..9d5f72d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -42,6 +42,7 @@
 037 metadata auto quick
 038 auto quick prealloc
 039 auto quick prealloc
+040 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

