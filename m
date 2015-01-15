Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbbAOKOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:14:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19303 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbbAOKO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:14:29 -0500
X-AuditID: cbfee68d-f79296d000004278-58-54b793036e6b
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>
Cc: david@fromorbit.com, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
 <1421165126-3585-10-git-send-email-linkinjeon@gmail.com>
 <20150114201710.GB49511@bfoster.bfoster>
In-reply-to: <20150114201710.GB49511@bfoster.bfoster>
Subject: RE: [PATCH v8 9/11] xfstests: generic/043: Test multiple fallocate
 insert/collapse range calls
Date: Thu, 15 Jan 2015 19:14:26 +0900
Message-id: <004301d030ac$0ad62960$20827c20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8HFfblg/gPWIGszLKUjAczsKp1gJE7vJ0AfQXG+Obx1UzIA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkWJd58vYQgw87+CyWTrzEbPHuc5XF
	lmP3GC2u373FbDFz3h02iz17T7JYXN41h82itecnu8WivluMDpwepxZJeOycdZfdo+nMUWaP
	1Re2Mnq833eVzaNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyHrx4zljw3Lri8IKzbA2Mywy6
	GDk5JARMJL7fWssOYYtJXLi3ng3EFhJYyigxc5EmTE1r9yKgGi6g+HRGiZ9r5rFCOH8ZJZYc
	awPKcHCwCWhL/NkiCtIgIuArcX/5R7AaZoHVjBLnp3RDNaxklHh18iorSBWngKnE61N7mEFs
	YYFMic8XboHZLAKqEmeO/QI7g1fAUqKnZyGULSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSFO
	VZDYcfY1I8QVThJfr+6FqhGR2PfiHSPIERICjRwSc/bsY4JYJiDxbfIhFpAPJARkJTYdgJoj
	KXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRmCU
	n/73rHcH4+0D1ocYBTgYlXh4Gfy2hwixJpYVV+YeYjQFumgis5Rocj4wleSVxBsamxlZmJqY
	GhuZW5opifMqSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDolnBhV1XLajXGiwzR95v2
	/N90/Mc75/V3p/zds/5C95dJBvYzpB52as2SXmvrmHL0zWpTtQ/OLzi0Lh+Vikmt62b5Lhm+
	7+tv1i/pUYdUuN+7qjtwGjS47zykeeiI/oFtzu9knPc9DvK4c3z/otLkk3e90znlXZP97q+c
	s4j1kbTi6cLn6753K7EUZyQaajEXFScCANNNN8ztAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQV3mydtDDGYfZLFYOvESs8W7z1UW
	W47dY7S4fvcWs8XMeXfYLPbsPclicXnXHDaL1p6f7BaL+m4xOnB6nFok4bFz1l12j6YzR5k9
	Vl/Yyujxft9VNo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmPHgxXPGgufWFYcXnGVrYFxm0MXIySEhYCLR2r2IHcIWk7hwbz1bFyMXh5DAdEaJn2vm
	sUI4fxkllhxrA6ri4GAT0Jb4s0UUpEFEwFfi/vKPYDXMAqsZJc5P6YZqWMko8erkVVaQKk4B
	U4nXp/Ywg9jCApkSny/cArNZBFQlzhz7xQZi8wpYSvT0LISyBSV+TL7HAmIzC2hJrN95nAnC
	lpfYvOYtM8SpChI7zr5mhLjCSeLr1b1QNSIS+168Y5zAKDQLyahZSEbNQjJqFpKWBYwsqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCk8gzqR2MKxssDjEKcDAq8fAy+G0PEWJNLCuuzD3E
	KMHBrCTC25kDFOJNSaysSi3Kjy8qzUktPsRoCvTpRGYp0eR8YILLK4k3NDYxM7I0Mje0MDI2
	VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpg7K6arCow/byWV5bRnCt79c7f5G2eOIWdd9k5
	m+yoJT6/NwqE7LkUaBc5ocO37kPjC/EHxXFSniossde6Kh3uMxY31GRd+jB3VYz/totrst5k
	Miv9u3X0jHFGjNfCWGajW/V15eof5h/yXNW0fR9TvndAVcYih8Wb58jNNxKo2J2cfXptdEWq
	EktxRqKhFnNRcSIAVhnlWzgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +_require_scratch
> > +_require_xfs_io_command "fiemap"
> > +_require_xfs_io_command "finsert"
> > +_require_xfs_io_command "fcollapse"
> > +_do_die_on_error=y
> 
> What is _do_die_on_error for? Seems like that's only relevant for using
> _do()?
> 
> > +src=$SCRATCH_MNT/testfile
> > +dest=$SCRATCH_MNT/testfile.dest
> > +BLOCKS=100
> > +BSIZE=`get_block_size $SCRATCH_MNT`
> > +
> 
> rm -f $seqres.full
> 
> ... to clear out the old .full file.
> 
> > +_scratch_mkfs MKFS_OPTIONS >> $seqres.full 2>&1
> 
> You don't need MKFS_OPTIONS here. In fact, this currently causes a mkfs
> failure (missing $) that we don't detect because we aren't checking that
> the mkfs actually succeeds. All we need to do here is:
> 
> _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> 
> If you dig down into _scratch_mkfs(), you'll see that it already
> includes $MKFS_OPTIONS and thus formats the fs as specified by the test
> config.
> 
> It might also be a good idea to check that the _scratch_mount below
> succeeds as well...
> 
> > +_scratch_mount >> $seqres.full 2>&1
> > +length=$(($BLOCKS * $BSIZE))
> > +
> > +# Write file
> > +$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $src > /dev/null
> > +cp $src $dest
> > +
> 
> It seems quite unlikely for this to not create a single extent given the
> smallish file size and freshly created fs, but who knows with various fs
> types, test configurations, test device sizes, etc. Another option could
> be to check the starting extent count and verify the ending extent count
> matches, rather than assume hardcoded values of 1.
> 
> To be honest, even just including the starting extent count in the
> golden output (e.g., add an fiemap command here as well) might be good
> enough to distinguish that failure path from something going wrong in
> the collapse path, should it ever occur.
> 
> > +# Insert alternate blocks
> > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +	offset=$((($j*$BSIZE)*2))
> > +	$XFS_IO_PROG -c "finsert $offset $BSIZE" $dest > /dev/null
> > +done
> > +
> > +# Check if 100 extents are present
> > +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> > +
> > +_check_scratch_fs
> > +if [ $? -ne 0 ]; then
> > +	status=1
> > +	exit
> > +fi
> > +
> > +# Collapse alternate blocks
> > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +	offset=$((($j*$BSIZE)))
> > +	$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $dest > /dev/null
> > +done
> > +
> > +# Check if 1 extents are present
> > +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> > +
> > +# compare original file and test file.
> > +cmp $src $dest || _fail "file bytes check failed"
> > +
> > +_check_scratch_fs
> > +if [ $? -ne 0 ]; then
> > +	status=1
> > +	exit
> > +fi
> > +
> > +umount $SCRATCH_MNT
> > +
> 
> The scratch device is unmounted and checked after each test that uses it
> so the above is unnecessary.
I checked your each review points. and updated patch.

Could you please review below patch ?
Thanks a lot!

------------------------------------------------------------------------------
Subject: [PATCH v9 9/11] xfstests: generic/043: Test multiple fallocate 
 insert/collapse range calls

This testcase(043) tries to test finsert range a single alternate block
mulitiple times and test merge code of collase range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/043     |   96 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/043.out |    2 +
 tests/generic/group   |    1 +
 3 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 tests/generic/043
 create mode 100644 tests/generic/043.out

diff --git a/tests/generic/043 b/tests/generic/043
new file mode 100644
index 0000000..a6f91ce
--- /dev/null
+++ b/tests/generic/043
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. generic/043
+#
+# Test multiple fallocate insert/collapse range calls on same file.
+# Call insert range a single alternate block multiple times until the file
+# is left with 100 extents and as much number of extents. And Call collapse
+# range about the previously inserted ranges to test merge code of collapse
+# range. Also check for data integrity and file system consistency.
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "fcollapse"
+_do_die_on_error=always
+src=$SCRATCH_MNT/testfile
+dest=$SCRATCH_MNT/testfile.dest
+BLOCKS=100
+BSIZE=`get_block_size $SCRATCH_MNT`
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount || _fail "mount failed"
+length=$(($BLOCKS * $BSIZE))
+
+# Write file
+_do "$XFS_IO_PROG -f -c \"pwrite 0 $length\" -c fsync $src"
+cp $src $dest
+extent_before=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
+
+# Insert alternate blocks
+for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+	offset=$((($j*$BSIZE)*2))
+	_do "$XFS_IO_PROG -c \"finsert $offset $BSIZE\" $dest"
+done
+
+# Check if 100 extents are present
+$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
+
+_check_scratch_fs
+if [ $? -ne 0 ]; then
+	status=1
+	exit
+fi
+
+# Collapse alternate blocks
+for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+	offset=$((($j*$BSIZE)))
+	_do "$XFS_IO_PROG -c \"fcollapse $offset $BSIZE\" $dest"
+done
+
+extent_after=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
+if [ $extent_before -ne $extent_after ]; then
+	echo "extents mismatched before = $extent_before after = $extent_after"
+fi
+
+# compare original file and test file.
+cmp $src $dest || _fail "file bytes check failed"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/043.out b/tests/generic/043.out
new file mode 100644
index 0000000..28427c5
--- /dev/null
+++ b/tests/generic/043.out
@@ -0,0 +1,2 @@
+QA output created by 043
+100
diff --git a/tests/generic/group b/tests/generic/group
index c0944b3..0a10bdd 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -45,6 +45,7 @@
 040 auto quick prealloc
 041 auto quick prealloc
 042 auto quick prealloc
+043 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.7


