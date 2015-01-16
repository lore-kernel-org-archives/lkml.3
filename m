Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbbAPHaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:30:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62949 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbAPHa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:30:27 -0500
X-AuditID: cbfee691-f79b86d000004a5a-79-54b8be116068
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Namjae Jeon'" <linkinjeon@gmail.com>, david@fromorbit.com, tytso@mit.edu,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
 <1421165126-3585-10-git-send-email-linkinjeon@gmail.com>
 <20150114201710.GB49511@bfoster.bfoster>
 <004301d030ac$0ad62960$20827c20$@samsung.com>
 <20150115122831.GA18876@bfoster.bfoster>
In-reply-to: <20150115122831.GA18876@bfoster.bfoster>
Subject: RE: [PATCH v8 9/11] xfstests: generic/043: Test multiple fallocate
 insert/collapse range calls
Date: Fri, 16 Jan 2015 16:30:24 +0900
Message-id: <005301d0315e$4af0db50$e0d291f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8HFfblg/gPWIGszLKUjAczsKp1gJE7vJ0AfQXG+MBwXuQKwJzxvNRm6cRGiA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkRFdw344Qg9VP+S2WTrzEbPHuc5XF
	lmP3GC2u373FbDFz3h02iz17T7JYXN41h82itecnu8WivluMDpwepxZJeOycdZfdo+nMUWaP
	1Re2Mnq833eVzaNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyepZdZC/Y7lrx+EovWwPjS9Mu
	Rk4OCQETieurrjJB2GISF+6tZ+ti5OIQEljKKHHh0CkmmKLTjzeygdhCAosYJQ78SoIo+sso
	MePcDeYuRg4ONgFtiT9bREFqRATUJe7Mm8ACUsMscJFRYuq810wQDS1MEnu2tzKDVHEKmEpM
	v9QPtkFYIFPi84VbYHEWAVWJ5hNLwbbxClhK3LsOcR6vgKDEj8n3WEBsZgEtifU7jzNB2PIS
	m9e8ZYa4VEFix9nXjCAHiQj4Sby+nA9RIiKx78U7RpAbJAQ6OSS+3pzGBLFLQOLb5EMsIPUS
	ArISmw5AjZGUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9d
	Lzk/dxMjMMZP/3s2cQfj/QPWhxgFOBiVeHgdNu0IEWJNLCuuzD3EaAp00URmKdHkfGAiySuJ
	NzQ2M7IwNTE1NjK3NFMS59WR/hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZFN/K6dQE/u
	fJ5O5q+sU/98vpfzgyl2T7qa7HTRiUk94RrnzvFoP6td81Tbg/vDFr1ZT+ZyV2b71JRX3GD0
	/vL7VNG2GzsVpv7jFr4RGOGvwF8s111y4rQ7m5flhlVc2yML51/b/Nc5UfiX1poD/SfK1Ouq
	37q0xjhPSXq4USjr3km1yFWbbyqxFGckGmoxFxUnAgCts3Fk7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAV3BfTtCDD6tYbNYOvESs8W7z1UW
	W47dY7S4fvcWs8XMeXfYLPbsPclicXnXHDaL1p6f7BaL+m4xOnB6nFok4bFz1l12j6YzR5k9
	Vl/Yyujxft9VNo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmNGz7CJ7wXbXisdXetkaGF+adjFyckgImEicfryRDcIWk7hwbz2YLSSwiFHiwK+kLkYu
	IPsvo8SMczeYuxg5ONgEtCX+bBEFqRERUJe4M28CC0gNs8BFRomp814zQTS0MEns2d7KDFLF
	KWAqMf1SPxOILSyQKfH5wi2wOIuAqkTziaVg23gFLCXuXb/KBGELSvyYfI8FxGYW0JJYv/M4
	E4QtL7F5zVtmiEsVJHacfc0IcpCIgJ/E68v5ECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWM
	LKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxghPIM+kdjKsaLA4xCnAwKvHwztiyI0SINbGs
	uDL3EKMEB7OSCO/GbUAh3pTEyqrUovz4otKc1OJDjKZAj05klhJNzgcmt7ySeENjEzMjSyNz
	QwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQimD4mDk6pBsZCz0WGqWZPV1uIL1tjyXX05c3V393T
	dQVTr6w40lp18MWaVDaNmTvWPKn7f3mX4MG39VnJuXwqM/lsdrS88mavjW2JV9zm9l90d0XK
	iXqhxU5icUmcDOEdn3r3+u1dZWl18cLqifuubHLJ/inkuVTnUaGM5KL2hyFrY5u5tNe6Gf+J
	4wytXqbEUpyRaKjFXFScCAAZhmSxNgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 15, 2015 at 07:14:26PM +0900, Namjae Jeon wrote:
> >
> > > > +_require_scratch
> > > > +_require_xfs_io_command "fiemap"
> > > > +_require_xfs_io_command "finsert"
> > > > +_require_xfs_io_command "fcollapse"
> > > > +_do_die_on_error=y
> > >
> > > What is _do_die_on_error for? Seems like that's only relevant for using
> > > _do()?
> > >
> > > > +src=$SCRATCH_MNT/testfile
> > > > +dest=$SCRATCH_MNT/testfile.dest
> > > > +BLOCKS=100
> > > > +BSIZE=`get_block_size $SCRATCH_MNT`
> > > > +
> > >
> > > rm -f $seqres.full
> > >
> > > ... to clear out the old .full file.
> > >
> > > > +_scratch_mkfs MKFS_OPTIONS >> $seqres.full 2>&1
> > >
> > > You don't need MKFS_OPTIONS here. In fact, this currently causes a mkfs
> > > failure (missing $) that we don't detect because we aren't checking that
> > > the mkfs actually succeeds. All we need to do here is:
> > >
> > > _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> > >
> > > If you dig down into _scratch_mkfs(), you'll see that it already
> > > includes $MKFS_OPTIONS and thus formats the fs as specified by the test
> > > config.
> > >
> > > It might also be a good idea to check that the _scratch_mount below
> > > succeeds as well...
> > >
> > > > +_scratch_mount >> $seqres.full 2>&1
> > > > +length=$(($BLOCKS * $BSIZE))
> > > > +
> > > > +# Write file
> > > > +$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $src > /dev/null
> > > > +cp $src $dest
> > > > +
> > >
> > > It seems quite unlikely for this to not create a single extent given the
> > > smallish file size and freshly created fs, but who knows with various fs
> > > types, test configurations, test device sizes, etc. Another option could
> > > be to check the starting extent count and verify the ending extent count
> > > matches, rather than assume hardcoded values of 1.
> > >
> > > To be honest, even just including the starting extent count in the
> > > golden output (e.g., add an fiemap command here as well) might be good
> > > enough to distinguish that failure path from something going wrong in
> > > the collapse path, should it ever occur.
> > >
> > > > +# Insert alternate blocks
> > > > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > > > +	offset=$((($j*$BSIZE)*2))
> > > > +	$XFS_IO_PROG -c "finsert $offset $BSIZE" $dest > /dev/null
> > > > +done
> > > > +
> > > > +# Check if 100 extents are present
> > > > +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> > > > +
> > > > +_check_scratch_fs
> > > > +if [ $? -ne 0 ]; then
> > > > +	status=1
> > > > +	exit
> > > > +fi
> > > > +
> > > > +# Collapse alternate blocks
> > > > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > > > +	offset=$((($j*$BSIZE)))
> > > > +	$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $dest > /dev/null
> > > > +done
> > > > +
> > > > +# Check if 1 extents are present
> > > > +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> > > > +
> > > > +# compare original file and test file.
> > > > +cmp $src $dest || _fail "file bytes check failed"
> > > > +
> > > > +_check_scratch_fs
> > > > +if [ $? -ne 0 ]; then
> > > > +	status=1
> > > > +	exit
> > > > +fi
> > > > +
> > > > +umount $SCRATCH_MNT
> > > > +
> > >
> > > The scratch device is unmounted and checked after each test that uses it
> > > so the above is unnecessary.
> > I checked your each review points. and updated patch.
> >
> > Could you please review below patch ?
> > Thanks a lot!
> >
> > ------------------------------------------------------------------------------
> > Subject: [PATCH v9 9/11] xfstests: generic/043: Test multiple fallocate
> >  insert/collapse range calls
> >
> > This testcase(043) tries to test finsert range a single alternate block
> > mulitiple times and test merge code of collase range.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  tests/generic/043     |   96 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/043.out |    2 +
> >  tests/generic/group   |    1 +
> >  3 files changed, 99 insertions(+), 0 deletions(-)
> >  create mode 100644 tests/generic/043
> >  create mode 100644 tests/generic/043.out
> >
> > diff --git a/tests/generic/043 b/tests/generic/043
> > new file mode 100644
> > index 0000000..a6f91ce
> > --- /dev/null
> > +++ b/tests/generic/043
> > @@ -0,0 +1,96 @@
> > +#! /bin/bash
> > +# FS QA Test No. generic/043
> > +#
> > +# Test multiple fallocate insert/collapse range calls on same file.
> > +# Call insert range a single alternate block multiple times until the file
> > +# is left with 100 extents and as much number of extents. And Call collapse
> > +# range about the previously inserted ranges to test merge code of collapse
> > +# range. Also check for data integrity and file system consistency.
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2014 Samsung Electronics.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +_require_scratch
> > +_require_xfs_io_command "fiemap"
> > +_require_xfs_io_command "finsert"
> > +_require_xfs_io_command "fcollapse"
> > +_do_die_on_error=always
> 
> Still not sure what the above is for, but otherwise this one looks fine
> to me:
Yes, It is not needed. I will remove it when I resend total patct-set.
Thanks!
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +src=$SCRATCH_MNT/testfile
> > +dest=$SCRATCH_MNT/testfile.dest
> > +BLOCKS=100
> > +BSIZE=`get_block_size $SCRATCH_MNT`
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> > +_scratch_mount || _fail "mount failed"
> > +length=$(($BLOCKS * $BSIZE))
> > +
> > +# Write file
> > +_do "$XFS_IO_PROG -f -c \"pwrite 0 $length\" -c fsync $src"
> > +cp $src $dest
> > +extent_before=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
> > +
> > +# Insert alternate blocks
> > +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +	offset=$((($j*$BSIZE)*2))
> > +	_do "$XFS_IO_PROG -c \"finsert $offset $BSIZE\" $dest"
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
> > +	_do "$XFS_IO_PROG -c \"fcollapse $offset $BSIZE\" $dest"
> > +done
> > +
> > +extent_after=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
> > +if [ $extent_before -ne $extent_after ]; then
> > +	echo "extents mismatched before = $extent_before after = $extent_after"
> > +fi
> > +
> > +# compare original file and test file.
> > +cmp $src $dest || _fail "file bytes check failed"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/043.out b/tests/generic/043.out
> > new file mode 100644
> > index 0000000..28427c5
> > --- /dev/null
> > +++ b/tests/generic/043.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 043
> > +100
> > diff --git a/tests/generic/group b/tests/generic/group
> > index c0944b3..0a10bdd 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -45,6 +45,7 @@
> >  040 auto quick prealloc
> >  041 auto quick prealloc
> >  042 auto quick prealloc
> > +043 auto quick prealloc
> >  053 acl repair auto quick
> >  062 attr udf auto quick
> >  068 other auto freeze dangerous stress
> > --
> > 1.7.7
> >
> >

