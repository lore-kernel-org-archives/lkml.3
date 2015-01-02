Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbbABJlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:41:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57549 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbABJlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:41:37 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-7d-54a667cfc762
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 5/11] xfstests: generic/039: Standard insert range tests
Date: Fri, 02 Jan 2015 18:41:35 +0900
Message-id: <004301d02670$4c3be250$e4b3a6f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmby05sEi/8cP1Q3uvcqgJyAMXnA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQPd8+rIQg/eXxCyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgyjg6ZwFjwXX9iu8/+1kbGNvUuxg5OSQETCTenOpk
	gbDFJC7cW8/WxcjFISSwlFFix+YTrDBFz5YtArOFBKYzSmxZlw5R9JdR4vu0R0xdjBwcbALa
	En+2iILUiAi4Ssy7+50RpIZZ4ASjxPrJS8A2CAt4S6y8/o0ZxGYRUJXY97CNDcTmFbCUmP3l
	DDuELSjxY/I9sHpmAS2J9TuPM0HY8hKb17xlhjhIQWLH2deMEMv0JD6vvc8IUSMise/FO7DF
	EgL32CW2bWpjhFgmIPFt8iEWkEMlBGQlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCR
	ZRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYHye/vdswg7GewesDzEKcDAq8fAqXFsaIsSa
	WFZcmXuI0RTooonMUqLJ+cAkkFcSb2hsZmRhamJqbGRuaaYkzvta6mewkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBkbPZ4df25+YZHBIcalzZ7dHgevxxaumrtbjPpTJW7ey90Qah68zw6tA
	7snbvors55CTc25duiraSoB94g6l4xf7D88Kn3Xjd/EZ+egP5urfqlzbj2rtLudvyzi3vdV7
	Yk2VR2GKvtsRzSNb/N1ndnFU/3GMnvlVSnjLwl/CCifPXJDVSTe+4abEUpyRaKjFXFScCADi
	CLPeygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoO759GUhBp17eC2WTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxdM4CxoLr
	+hXff/azNjC2qXcxcnJICJhIPFu2iBXCFpO4cG89G4gtJDCdUWLLuvQuRi4g+y+jxPdpj5i6
	GDk42AS0Jf5sEQWpERFwlZh39zsjSA2zwAlGifWTl7CAJIQFvCVWXv/GDGKzCKhK7HvYBjaU
	V8BSYvaXM+wQtqDEj8n3wOqZBbQk1u88zgRhy0tsXvOWGeIgBYkdZ18zQizTk/i89j4jRI2I
	xL4X7xgnMArMQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Oh/
	Jr2DcVWDxSFGAQ5GJR5ehWtLQ4RYE8uKK3MPMUpwMCuJ8PbJLQkR4k1JrKxKLcqPLyrNSS0+
	xGgK9OlEZinR5HxgYsoriTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCU
	amCcwnJBZ7fNOkZxU3WTvU+O/xK72WHjcE2xJmLGI++GP/s3M1x1+hreubaO/1z0mrcN9i3L
	piydwfZY5gHXilmV7q0fWK8zG1q+XHWxcnc2rx3b3CWheszF7Gq+ZeFvtb6YflZdUfJ9y0P7
	2Xvjns5gjfDNXVto9HXz1283tztF7bM4K2YoosevxFKckWioxVxUnAgAbxmrhBQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(039) tries to test various corner cases for finsert range
functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 common/punch          |  5 ++++
 common/rc             |  2 +-
 tests/generic/039     | 65 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/039.out | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 5 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 tests/generic/039
 create mode 100644 tests/generic/039.out

diff --git a/common/punch b/common/punch
index 237b4d8..a75f4cf 100644
--- a/common/punch
+++ b/common/punch
@@ -527,6 +527,11 @@ _test_generic_punch()
 		return
 	fi
 
+	# If zero_cmd is finsert, don't check unaligned offsets
+	if [ "$zero_cmd" == "finsert" ]; then
+		return
+	fi
+
 	echo "	16. data -> cache cold ->hole"
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
diff --git a/common/rc b/common/rc
index 5ce3322..a32f3f2 100644
--- a/common/rc
+++ b/common/rc
@@ -1520,7 +1520,7 @@ _require_xfs_io_command()
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
 		;;
-	"fpunch" | "fcollapse" | "zero" | "fzero" )
+	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" )
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
diff --git a/tests/generic/039 b/tests/generic/039
new file mode 100644
index 0000000..76f89f5
--- /dev/null
+++ b/tests/generic/039
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/039
+#
+# Standard insert range tests
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for finsert range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Samsung Electronics.  All Rights Reserved.
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
+_test_generic_punch falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/039.out b/tests/generic/039.out
new file mode 100644
index 0000000..d1e8320
--- /dev/null
+++ b/tests/generic/039.out
@@ -0,0 +1,78 @@
+QA output created by 039
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
+cf845a781c107ec1346e849c9dd1b7e8
+	4. hole -> data
+0: [0..31]: hole
+1: [32..47]: extent
+2: [48..55]: hole
+adb08a6d94a3b5eff90fdfebb2366d31
+	5. hole -> unwritten
+0: [0..31]: hole
+1: [32..47]: extent
+2: [48..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..55]: hole
+be0f35d4292a20040766d87883b0abd1
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+be0f35d4292a20040766d87883b0abd1
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+adb08a6d94a3b5eff90fdfebb2366d31
+	10. hole -> data -> hole
+0: [0..39]: hole
+1: [40..47]: extent
+2: [48..63]: hole
+0487b3c52810f994c541aa166215375f
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
+0487b3c52810f994c541aa166215375f
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
index 1e89848..d764c78 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -41,6 +41,7 @@
 036 auto aio rw stress
 037 metadata auto quick
 038 auto stress
+039 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.5.5

