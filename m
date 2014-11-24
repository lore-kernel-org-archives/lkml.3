Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaKXGQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:16:54 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10491 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaKXGQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:16:50 -0500
X-AuditID: cbfee68d-f79296d000004278-67-5472cd509b94
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH v6 5/10] xfstests: generic/038: Standard insert range tests
Date: Mon, 24 Nov 2014 15:16:48 +0900
Message-id: <002e01d007ae$3a8f7b10$afae7130$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAHrOimcfpjb+/xQxKJHnDXlcDGyw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkUDfgbFGIweomDYulEy8xW2w5do/R
	Yua8O2wWe/aeZLG4vGsOm0Vrz092i0V9txgd2D1OLZLwaDpzlNlj9YWtjB59W1YxenzeJBfA
	GsVlk5Kak1mWWqRvl8CVMbfrI1vBTf2K41OmsTUwdqh3MXJySAiYSEy+u4IVwhaTuHBvPVsX
	IxeHkMBSRon5Mw8xwxRdfbSUESKxiFHi0NcrzBDOX0aJLVdPsHcxcnCwCWhL/NkiCtIgIuAq
	Me/ud7AGZpBJFx8/YQSpERbwlnjxTxekhkVAVeLc5E6wzbwClhJ/l71lgrAFJX5MvscCYjML
	aEms33mcCcKWl9i85i3UQQoSO86+BhspIqAn8eauBkSJiMS+F+/A1koIXGKXuHDrDxPELgGJ
	b5MPsYDUSwjISmw6ADVGUuLgihssExjFZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IkO9
	4sTc4tK8dL3k/NxNjMBYPP3vWe8OxtsHrA8xCnAwKvHwfthYFCLEmlhWXJl7iNEU6KKJzFKi
	yfnAiM8riTc0NjOyMDUxNTYytzRTEudVlPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR
	8eS15fd603qk7kafSI7jmOhw/nOXQACvJ6/d4nL+1e0F91l+Fh2UlCq4urejPCApYcnJLf13
	BWXYV54rTiqeG3hW/6LC4SKpwPBsz13qrbrdN05UJ5sLrHjA/76+cPXNzkcrRLUXLWrWWyoT
	qlvAv3nSkaLcLqf9Kt1OVxqmvYxnt/zn1qvEUpyRaKjFXFScCAAIwNaRwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jAd2As0UhBnP/y1ksnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlzuz6yFdzUrzg+ZRpbA2OH
	ehcjJ4eEgInE1UdLGSFsMYkL99azdTFycQgJLGKUOPT1CjOE85dRYsvVE+xdjBwcbALaEn+2
	iII0iAi4Ssy7+50RpIZZYCmjxMXHTxhBaoQFvCVe/NMFqWERUJU4N7mTFcTmFbCU+LvsLROE
	LSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSEOUpDYcfY12EgRAT2JN3c1IEpEJPa9eMc4gVFg
	FpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf6M6kdjCsbLA4x
	CnAwKvHwfthYFCLEmlhWXJl7iFGCg1lJhPfsv8IQId6UxMqq1KL8+KLSnNTiQ4ymQI9OZJYS
	Tc4HJqG8knhDYxMzI0sjc0MLI2NzJXHeGzdzQ4QE0hNLUrNTUwtSi2D6mDg4pRoYGQ4umuUu
	+aWxqODRlNkK827ezGJjse2693Ld+yy+j8ZXpT9zH6wyPt6spPKkIv12kMcZMenHU7qO1Oqe
	aem4XxmuX96jHKe346j87YDwIl6LL/G7Z1U/in9ese3gEc/ffy6cTHC80qwin3zbq8O0UN8u
	tcfj2KysOgehvmsvm0OOXQuYmblSiaU4I9FQi7moOBEAq9F8jQoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(038) tries to test various corner cases for finsert range
functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 common/punch          |  5 ++++
 common/rc             |  2 +-
 tests/generic/038     | 65 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/038.out | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 5 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 tests/generic/038
 create mode 100644 tests/generic/038.out

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
index d5e3aff..ca4177f 100644
--- a/common/rc
+++ b/common/rc
@@ -1486,7 +1486,7 @@ _require_xfs_io_command()
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
 		;;
-	"fpunch" | "fcollapse" | "zero" | "fzero" )
+	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" )
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
diff --git a/tests/generic/038 b/tests/generic/038
new file mode 100644
index 0000000..0ce0e61
--- /dev/null
+++ b/tests/generic/038
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/038
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
diff --git a/tests/generic/038.out b/tests/generic/038.out
new file mode 100644
index 0000000..3ebdb43
--- /dev/null
+++ b/tests/generic/038.out
@@ -0,0 +1,78 @@
+QA output created by 038
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
index 9f355fc..7d6f227 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -40,6 +40,7 @@
 035 auto quick
 036 auto aio rw stress
 037 metadata auto quick
+038 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

