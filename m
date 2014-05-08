Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaEHKf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:35:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27069 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaEHKfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:35:23 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-05-536b5de9ccc4
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: [PATCH v2 8/10] xfstests: generic/030: Delayed allocation multi insert
Date: Thu, 08 May 2014 19:35:21 +0900
Message-id: <003e01cf6aa9$36b14c00$a413e400$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qqSVS59PZm3FqQM22KLrPnqc6tA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkRPdVbHawweatjBZLJ15itthy7B6j
	xcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6sHucWiTh0XTmKLPH6gtbGT36tqxi9Pi8SS6A
	NYrLJiU1J7MstUjfLoErY8+cZewFl1UqTp9ewdrAeESui5GTQ0LAROLp1gZWCFtM4sK99Wwg
	tpDAUkaJCccjYWoatvwGquECii9ilOj7OosRwvnLKDF94QamLkYODjYBbYk/W0RBGkQEPCUW
	H9/KBlLDLLCSUeLe8Y9sIDXCAv4Suw6LgNSwCKhKdPT1gS3jFbCUeLj4KDOELSjxY/I9FhCb
	WUBLYv3O40wQtrzE5jVvmSEOUpDYcfY1I8QuPYkNCxrZIWpEJPa9eAd2m4TAJXaJZ49mM0Es
	E5D4NvkQC8gNEgKyEpsOQM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9
	yESvODG3uDQvXS85P3cTIzAWT/97NmEH470D1ocYk4HWT2SWEk3OB8ZyXkm8obGZkYWpiamx
	kbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwRuxPXXbpQGq+Hsu1+1ZH
	D6wLzJ+1L+5QU87cDQsLP29TNtV0zzh37mO1cIPG7Y9TdfdvjuO7dmPP3JOz4+S2yputffE9
	nemuXNI/7VXMZRt/HZ7ZxJpwv+TDgTcXaye6ntzWpvEi+tDjns03fPh8Sxfk3NqV26FwZn3B
	ipVeThsenL6sb9FmqKnEUpyRaKjFXFScCABBaCUm2wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd2XsdnBBjdWmFksnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBl75ixjL7isUnH69ArWBsYj
	cl2MnBwSAiYSDVt+s0LYYhIX7q1n62Lk4hASWMQo0fd1FiOE85dRYvrCDUxdjBwcbALaEn+2
	iII0iAh4Siw+vhWsgVlgJaPEveMf2UBqhAX8JXYdFgGpYRFQlejo62MDsXkFLCUeLj7KDGEL
	SvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmiIMUJHacfc0IsUtPYsOCRnaIGhGJfS/eMU5gFJiF
	ZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBsf5MagfjygaLQ4wC
	HIxKPLwZzlnBQqyJZcWVuYcYJTiYlUR4efyzg4V4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5
	H5iG8kriDY1NzIwsjcwNLYyMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsaQ0v8Xz
	U1vif6acunsx0nHLXcJsRU25GSZIiPtK31+U3LGjQCK8VmSRwL8dtYL3GSWlFX//f/zcjed+
	nV+Z7P0rb4oWNyn5rFzAPf8LC8u7d1d/1pt47w9Yxf3ydvOp35cbZN+dato1advVlhyGGWpc
	zRP8//s8aS9+qS4srDfZ/rPV8Rs1SizFGYmGWsxFxYkAbMKYiTkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(030) tries to test various corner cases with delayed extents and
pre-existing holes for finsert range functionality over different type of
extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/030     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/030.out | 50 +++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 116 insertions(+)
 create mode 100755 tests/generic/030
 create mode 100644 tests/generic/030.out

diff --git a/tests/generic/030 b/tests/generic/030
new file mode 100755
index 0000000..02680b7
--- /dev/null
+++ b/tests/generic/030
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/030
+#
+# Delayed allocation multi insert range tests
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
+_test_generic_punch -d -k falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/030.out b/tests/generic/030.out
new file mode 100644
index 0000000..eed3303
--- /dev/null
+++ b/tests/generic/030.out
@@ -0,0 +1,50 @@
+QA output created by 030
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: extent
+2: [24..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	2. into allocated space
+0: [0..55]: extent
+64e72217eebcbdf31b1b058f9f5f476a
+	3. into unwritten space
+0: [0..55]: extent
+22b7303d274481990b5401b6263effe0
+	4. hole -> data
+0: [0..55]: extent
+c4fef62ba1de9d91a977cfeec6632f19
+	5. hole -> unwritten
+0: [0..55]: extent
+1ca74f7572a0f4ab477fdbb5682e5f61
+	6. data -> hole
+0: [0..55]: extent
+be0f35d4292a20040766d87883b0abd1
+	7. data -> unwritten
+0: [0..55]: extent
+bddb1f3895268acce30d516a99cb0f2f
+	8. unwritten -> hole
+0: [0..55]: extent
+f8fc47adc45b7cf72f988b3ddf5bff64
+	9. unwritten -> data
+0: [0..55]: extent
+c4fef62ba1de9d91a977cfeec6632f19
+	10. hole -> data -> hole
+0: [0..63]: extent
+52af1bfcbf43f28af2328de32e0567e5
+	11. data -> hole -> data
+0: [0..39]: extent
+1: [40..47]: hole
+2: [48..63]: extent
+e3a8d52acc4d91a8ed19d7b6f4f26a71
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+52af1bfcbf43f28af2328de32e0567e5
+	13. data -> unwritten -> data
+0: [0..63]: extent
+2b22165f4a24a2c36fd05ef00b41df88
+	14. data -> hole @ EOF
+0: [0..55]: extent
+aa0f20d1edcdbce60d8ef82700ba30c3
+	15. data -> hole @ 0
+0: [0..55]: extent
+86c9d033be2761385c9cfa203c426bb2
diff --git a/tests/generic/group b/tests/generic/group
index f5fe53c..9187d9e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -32,6 +32,7 @@
 027 auto quick prealloc
 028 auto quick prealloc
 029 auto quick prealloc
+030 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

