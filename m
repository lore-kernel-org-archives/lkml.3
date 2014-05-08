Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaEHKe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:34:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43973 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaEHKe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:34:26 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-63-536b5db075aa
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: [PATCH v2 7/10] xfstests: generic/029: Multi insert range tests
Date: Thu, 08 May 2014 19:34:24 +0900
Message-id: <003d01cf6aa9$14808ce0$3d81a6a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qqQEKNAa6fIjXQJ+ZGjnVsSYHIA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkWHdDbHawQddxNYulEy8xW2w5do/R
	Yua8O2wWe/aeZLG4vGsOm0Vrz092i0V9txgd2D1OLZLwaDpzlNlj9YWtjB59W1YxenzeJBfA
	GsVlk5Kak1mWWqRvl8CVcf/kL6aCxSoVD66fZ2pgnC3XxcjJISFgItF9ci4jhC0mceHeerYu
	Ri4OIYGljBJr9hxkhinaNb+TFSIxnVGic/4zKOcvo8TMq/eA2jk42AS0Jf5sEQVpEBHwlFh8
	fCvYJGaBlYwS945/ZANJCAt4SNyetYAdxGYRUJXYtO8PE0gvr4ClxL49BiBhXgFBiR+T77GA
	2MwCWhLrdx5ngrDlJTaveQt1kILEjrOvGSF26Uk8fH6dHaJGRGLfi3eMIHslBK6xS8z7sgJq
	l4DEt8mHWEB2SQjISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0
	ImO94sTc4tK8dL3k/NxNjMBoPP3vWf8OxrsHrA8xJgOtn8gsJZqcD4zmvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeOTJYuOEpquWnUrn1Grk
	by550Kagcut647SFLtzlOwXKHeZeOzijYmKkZ8C6fFm1fb4XbjGZWlizNhV94HJxbdlz/2JM
	ONOLY6dLZda5dmgtNue9vevT7pdC8b/7/Do+tmW7tzSeL5zN/ra0ryI18vFLNRN7MXHPSu7X
	JVNannYx8c+sP+KixFKckWioxVxUnAgAwJAWP9wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jQd0NsdnBBif+ylosnXiJ2WLLsXuM
	FjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowO5xapGER9OZo8weqy9sZfTo27KK0ePzJrkA
	1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBn3T/5iKlisUvHg+nmmBsbZ
	cl2MnBwSAiYSu+Z3skLYYhIX7q1n62Lk4hASmM4o0Tn/GSuE85dRYubVe4xdjBwcbALaEn+2
	iII0iAh4Siw+vhWsgVlgJaPEveMf2UASwgIeErdnLWAHsVkEVCU27fvDBNLLK2ApsW+PAUiY
	V0BQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jJDHKQgsePsa0aIXXoSD59fZ4eoEZHY9+Id4wRG
	gVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc68+kdzCuarA4
	xCjAwajEw5vhnBUsxJpYVlyZe4hRgoNZSYSXxz87WIg3JbGyKrUoP76oNCe1+BBjMtCjE5ml
	RJPzgWkoryTe0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY42ef
	ZmXnCKtvSfA22pr63Sfqi6uhiuqDtHn38h/Vt8oeu7Du4rWuIjvnA/URC1Meh57zTNXRnuYW
	s9OsN6dG2K3iz4YoL9ukcrfkc3s1L8+2jS9/1Pd4e6RB9+XT3pcMjtRobZh6av0tfYPOnV+C
	jL9pJjPlxZmcDs67WTh92vHn+79fPsWtxFKckWioxVxUnAgAJWtkozkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(029) tries to test various corner cases with pre-existing holes
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/029     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/029.out | 50 +++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 116 insertions(+)
 create mode 100755 tests/generic/029
 create mode 100644 tests/generic/029.out

diff --git a/tests/generic/029 b/tests/generic/029
new file mode 100755
index 0000000..13d7164
--- /dev/null
+++ b/tests/generic/029
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/029
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
diff --git a/tests/generic/029.out b/tests/generic/029.out
new file mode 100644
index 0000000..0a2b659
--- /dev/null
+++ b/tests/generic/029.out
@@ -0,0 +1,50 @@
+QA output created by 029
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
index 0ef13be..f5fe53c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -31,6 +31,7 @@
 026 acl quick auto
 027 auto quick prealloc
 028 auto quick prealloc
+029 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

