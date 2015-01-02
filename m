Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbbABJmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:42:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33980 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbbABJm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:42:27 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-64-54a66801dc33
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 8/11] xfstests: generic/042: Delayed allocation multi insert
Date: Fri, 02 Jan 2015 18:42:25 +0900
Message-id: <004601d02670$6a3c1720$3eb44560$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAmb5QXsZEVoK/3SFCj8CUpkucXaw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkUJcxY1mIweQjWhZLJ15itnj3ucpi
	y7F7jBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKptH
	35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZRz6foixYKNmxbujr1kbGFcpdTFyckgImEjM2tHJ
	BmGLSVy4tx7I5uIQEljKKHH/1QMmmKKFj54zQiSmM0qsPbyKFcL5yyjxcvc/IIeDg01AW+LP
	FlGQBhEBV4l5d7+DNTALnGCUWD95CQtIQljAX2Ji7z1GkHoWAVWJYxczQcK8ApYSUxufs0DY
	ghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZ4iAFiR1nXzNC7NKTuL3gJRtEjYjEvhfvwPZKCNxj
	l7g55QFYgkVAQOLb5EMsIHslBGQlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWj
	aGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYHye/vdswg7GewesDzEKcDAq8fAqXFsaIsSaWFZc
	mXuI0RTooonMUqLJ+cAkkFcSb2hsZmRhamJqbGRuaaYkzvta6mewkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBkbBHfv+8pZYJ9ye1XTzxBUp43yF59XSv8su8uUX9Jkt2at/WOehkucx09IP
	/Kc5TNhYgi/cbl8rdq751/oLWn5hgof3l7Ew3ll9qCKoul89Ypm55/xgtsggq2KbAybXnutP
	fs7R9m5v1K8sjUnzg50NU4sY5Bp3+77ZaprFG+XxvaP03U+1CUosxRmJhlrMRcWJAFkroUzK	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoC5jxrIQgz0LlSyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx6PshxoKN
	mhXvjr5mbWBcpdTFyMkhIWAisfDRc0YIW0ziwr31bF2MXBxCAtMZJdYeXsUK4fxllHi5+x+Q
	w8HBJqAt8WeLKEiDiICrxLy73xlBapgFTjBKrJ+8hAUkISzgLzGx9x4jSD2LgKrEsYuZIGFe
	AUuJqY3PWSBsQYkfk++B2cwCWhLrdx5ngrDlJTavecsMcZCCxI6zrxkhdulJ3F7wkg2iRkRi
	34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw9D+T
	3sG4qsHiEKMAB6MSD6/CtaUhQqyJZcWVuYcYJTiYlUR4++SWhAjxpiRWVqUW5ccXleakFh9i
	NAV6dCKzlGhyPjAx5ZXEGxqbmBlZGpkbWhgZmyuJ8yrZt4UICaQnlqRmp6YWpBbB9DFxcEo1
	MEZ/09y54Lraj11aBhNrzG8bSOXuledP/i7u6OkafOmu+9HINwsflEg9/Ns/3eqV+Q9d47l1
	VTe6Lr48/dJb/46ugHo41/orf9v2bNELvGPGeuzisgc9IXtuaXIwRX4w/6STzjr70fflr1/K
	JT5K51+zWae42jBqg8U2g6tuX53Dp//+Xj7pxWIlluKMREMt5qLiRADAl1b3FAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(042) tries to test various corner cases with delayed extents and
pre-existing holes for finsert range functionality over different type of
extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/042     | 65 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/042.out | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 146 insertions(+)
 create mode 100644 tests/generic/042
 create mode 100644 tests/generic/042.out

diff --git a/tests/generic/042 b/tests/generic/042
new file mode 100644
index 0000000..ea9fd3c
--- /dev/null
+++ b/tests/generic/042
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/042
+#
+# Delayed allocation multi insert range tests
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
+_test_generic_punch -d -k falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/042.out b/tests/generic/042.out
new file mode 100644
index 0000000..1618e9d
--- /dev/null
+++ b/tests/generic/042.out
@@ -0,0 +1,80 @@
+QA output created by 042
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
index 62660cc..c0944b3 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -44,6 +44,7 @@
 039 auto quick prealloc
 040 auto quick prealloc
 041 auto quick prealloc
+042 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.5.5

