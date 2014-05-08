Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaEHKdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:33:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9011 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaEHKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:33:16 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a5-536b5d6a5c06
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: [PATCH v2 6/10] xfstests: generic/028: Delayed allocation insert range
Date: Thu, 08 May 2014 19:33:13 +0900
Message-id: <003c01cf6aa8$ea9c5e40$bfd51ac0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qqOKP6A3WltxpTZWOu9+eYf6+wQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkWDcrNjvY4ESXmMXSiZeYLbYcu8do
	MXPeHTaLPXtPslhc3jWHzaK15ye7xaK+W4wO7B6nFkl4NJ05yuyx+sJWRo++LasYPT5vkgtg
	jeKySUnNySxLLdK3S+DKaF+7hq3gvVpF0+RHzA2MyxW6GDk4JARMJBb81+5i5AQyxSQu3FvP
	1sXIxSEksJRRYtGCd2wwNV8+V0DEFzFK7DuwhhnC+cso0dVzhAWkiE1AW+LPFlGQQSICnhKL
	j28FG8QssJJR4t7xj2wgCWEBf4nPy1aygtgsAqoSqzdfB1vAK2ApMemNCUiYV0BQ4sfkeywg
	NrOAlsT6nceZIGx5ic1r3jJDHKogsePsa0aIXXoSj2/dYoaoEZHY9+IdI8heCYFr7BI9fyax
	QewSkPg2+RALxDOyEpsOQM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9
	yFivODG3uDQvXS85P3cTIzAST/971r+D8e4B60OMyUDrJzJLiSbnAyM5ryTe0NjMyMLUxNTY
	yNzSjDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwThfa+tj/X3H8j42+9/b8
	tNb9XSOgc6Xl8Y+I/8v3bf9+7d/yaYZr3uqk6G+1nyxgNtVo7qvZzWJpN9JTNXfvbj766fZO
	111ZKqHf68IaraeWv3by9im/XbZNNGJbnZT1K6nrHx/5qr14NefavzLBkBUaD1hFmY6sTSu5
	vFVd7fSk4kv53p8/vVViKc5INNRiLipOBACtBvhZ2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAd2s2Oxgg+NPeSyWTrzEbLHl2D1G
	i5nz7rBZ7Nl7ksXi8q45bBatPT/ZLRb13WJ0YPc4tUjCo+nMUWaP1Re2Mnr0bVnF6PF5k1wA
	a1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoz2tWvYCt6rVTRNfsTcwLhc
	oYuRg0NCwETiy+eKLkZOIFNM4sK99WxdjFwcQgKLGCX2HVjDDOH8ZZTo6jnCAtLAJqAt8WeL
	KEiDiICnxOLjW8EamAVWMkrcO/6RDSQhLOAv8XnZSlYQm0VAVWL15utsIL28ApYSk96YgIR5
	BQQlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPEQQoSO86+ZoTYpSfx+NYtZogaEYl9L94xTmAU
	mIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGR/kxqB+PKBotD
	jAIcjEo8vBnOWcFCrIllxZW5hxglOJiVRHh5/LODhXhTEiurUovy44tKc1KLDzEmAz06kVlK
	NDkfmITySuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGxUkLi
	faXGt2MGZXyzEq9Zue97MsnY5cCkbeqC8212sy+omVM0EZhgklZWe2WttmMVmTRXYVO42MS3
	7r+2TNhwSkj78H6r+nabAy+6r0XsvC3kmF4ka9JUIjlf9b63u7a9dSFn9OkE+7DgrNm3z0k4
	vYn6+FuZZc5X1XdiH555vP3bavWgOkuJpTgj0VCLuag4EQCG5h6nOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This testcase(028) tries to test various corner cases with delayed extents
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/028     | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/028.out | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 132 insertions(+)
 create mode 100755 tests/generic/028
 create mode 100644 tests/generic/028.out

diff --git a/tests/generic/028 b/tests/generic/028
new file mode 100755
index 0000000..bc6f9a6
--- /dev/null
+++ b/tests/generic/028
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/028
+#
+# Delayed allocation insert range tests
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
+_test_generic_punch -d falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/028.out b/tests/generic/028.out
new file mode 100644
index 0000000..30af9a7
--- /dev/null
+++ b/tests/generic/028.out
@@ -0,0 +1,66 @@
+QA output created by 028
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
index 6ab5618..0ef13be 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -30,6 +30,7 @@
 025 auto quick
 026 acl quick auto
 027 auto quick prealloc
+028 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

