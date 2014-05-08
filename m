Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaEHKcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:32:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43576 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaEHKcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:32:22 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-14-536b5d348e50
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: [PATCH v2 5/10] xfstests: generic/027: Standard insert range tests
Date: Thu, 08 May 2014 19:32:20 +0900
Message-id: <003b01cf6aa8$cab3e170$601ba450$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qqKzthvi/gId6QlucXFZLQIM8EA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkRNckNjvY4PELQ4ulEy8xW2w5do/R
	Yua8O2wWe/aeZLG4vGsOm0Vrz092i0V9txgd2D1OLZLwaDpzlNlj9YWtjB59W1YxenzeJBfA
	GsVlk5Kak1mWWqRvl8CVMWHmNeaCh7oVj747NDAeUu1i5OSQEDCR6D+/hh3CFpO4cG89G4gt
	JLCUUeLfNwmYmk2L9zJ3MXIBxRcxSnzt2AHl/GWUODvtI1AHBwebgLbEny2iIA0iAp4Si49v
	ZQOpYRZYyShx7zhEjbCAt8TfdzwgNSwCqhL7//wDW8wrYCmx8P0xNghbUOLH5HssIDazgJbE
	+p3HmSBseYnNa94yQxykILHj7GtGiF16Ek0LnrJD1IhI7HvxjhFkr4TAOXaJ7p52JohlAhLf
	Jh9iAblBQkBWYtMBqDmSEgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXmegV
	J+YWl+al6yXn525iBEbi6X/PJuxgvHfA+hBjMtD6icxSosn5wEjOK4k3NDYzsjA1MTU2Mrc0
	I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGpkjOle0L53PLOL7r5XlQGaw1
	w9+xTDt2SdP1jM/7Q4vq/zj7W2S3cPifDPJMs615c1N6HqfeRPttQV8vOOjV5bP3yjXvXW4W
	82Si35GE6uJH6079kA/x6hB36zQ9Vf/9V+KRD6+arq9avv+D7Rmj6fL7T/bdZ/xWaqBv/FvR
	TnnzbrcZV5iVWIozEg21mIuKEwG5SeYn2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAV2T2OxggwufNSyWTrzEbLHl2D1G
	i5nz7rBZ7Nl7ksXi8q45bBatPT/ZLRb13WJ0YPc4tUjCo+nMUWaP1Re2Mnr0bVnF6PF5k1wA
	a1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowJM68xFzzUrXj03aGB8ZBq
	FyMnh4SAicSmxXuZIWwxiQv31rN1MXJxCAksYpT42rGDGcL5yyhxdtpHoAwHB5uAtsSfLaIg
	DSICnhKLj28Fa2AWWMkoce84RI2wgLfE33c8IDUsAqoS+//8YwexeQUsJRa+P8YGYQtK/Jh8
	jwXEZhbQkli/8zgThC0vsXnNW6iDFCR2nH3NCLFLT6JpwVN2iBoRiX0v3jFOYBSYhWTULCSj
	ZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZH+TGoH48oGi0OMAhyMSjy8
	Gc5ZwUKsiWXFlbmHGCU4mJVEeHn8s4OFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YhPJK
	4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgZGdX3AzU9S+X5xs
	azfH/Spa+O60stl21fefAkt2bzgun3nhzwPxNMMdApNecLcw7rZTvfDwF/upKQnML2YK32vl
	45PmXNC5Q/UUQ8fyq3tv9ngcXMrtpj4nsYz1/4p19frv/TxSXryWuNHPJHjvsPUD5eJex32+
	IRfu3XrIWvNAjTXUQuvq+wNKLMUZiYZazEXFiQBwQcipOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(027) tries to test various corner cases for finsert range
functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 common/punch          |  5 ++++
 common/rc             |  2 +-
 tests/generic/027     | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/027.out | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 5 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/027
 create mode 100644 tests/generic/027.out

diff --git a/common/punch b/common/punch
index f2d538c..4cc50d5 100644
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
index 5c13db5..3af3a20 100644
--- a/common/rc
+++ b/common/rc
@@ -1237,7 +1237,7 @@ _require_xfs_io_command()
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
 		;;
-	"fpunch" | "fcollapse" | "zero" | "fzero" )
+	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" )
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
diff --git a/tests/generic/027 b/tests/generic/027
new file mode 100755
index 0000000..f2f7642
--- /dev/null
+++ b/tests/generic/027
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/027
+#
+# Standard insert range tests
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
+_test_generic_punch falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/027.out b/tests/generic/027.out
new file mode 100644
index 0000000..9b5ec15
--- /dev/null
+++ b/tests/generic/027.out
@@ -0,0 +1,66 @@
+QA output created by 027
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
+cf845a781c107ec1346e849c9dd1b7e8
+	4. hole -> data
+0: [0..7]: hole
+1: [8..23]: extent
+2: [24..31]: hole
+3: [32..47]: extent
+4: [48..55]: hole
+adb08a6d94a3b5eff90fdfebb2366d31
+	5. hole -> unwritten
+0: [0..7]: hole
+1: [8..23]: extent
+2: [24..31]: hole
+3: [32..47]: extent
+4: [48..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	6. data -> hole
+0: [0..31]: extent
+1: [32..55]: hole
+be0f35d4292a20040766d87883b0abd1
+	7. data -> unwritten
+0: [0..47]: extent
+1: [48..55]: hole
+be0f35d4292a20040766d87883b0abd1
+	8. unwritten -> hole
+0: [0..31]: extent
+1: [32..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	9. unwritten -> data
+0: [0..47]: extent
+1: [48..55]: hole
+adb08a6d94a3b5eff90fdfebb2366d31
+	10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..31]: extent
+2: [32..39]: hole
+3: [40..47]: extent
+4: [48..63]: hole
+0487b3c52810f994c541aa166215375f
+	11. data -> hole -> data
+0: [0..39]: extent
+1: [40..47]: hole
+2: [48..63]: extent
+e3a8d52acc4d91a8ed19d7b6f4f26a71
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+0487b3c52810f994c541aa166215375f
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
index 961f4e5..6ab5618 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -29,6 +29,7 @@
 024 auto quick
 025 auto quick
 026 acl quick auto
+027 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

