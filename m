Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbbAGFuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:50:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11976 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbAGFuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:50:16 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-c5-54acc91626fe
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
References: <004701d02670$73dcb0a0$5b9611e0$@samsung.com>
 <20150106191010.GJ5874@bfoster.bfoster>
In-reply-to: <20150106191010.GJ5874@bfoster.bfoster>
Subject: RE: [PATCH v7 9/11] xfstests: generic/043: Test multiple fallocate
 insert/collapse range calls
Date: Wed, 07 Jan 2015 14:50:13 +0900
Message-id: <001a01d02a3d$ce7462d0$6b5d2870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIvGHOauN9jkNRBdlZw+n1ZWUFkpgEzhfS0m+yXdxA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkWFfs5JoQg8/rhSyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgyrjT9pKlYBV/RePsTpYGxjXcXYwcHBICJhJ7jyR2
	MXICmWISF+6tZ+ti5OIQEljKKPGp6wUbRMJEYn3PDKjEdEaJv70X2CGcv4wSNw73soBMYhPQ
	lvizRRSkQURAXeLOvAksIDXMAp8YJR5eOcAMkhASSJb42/YJbCon0NSHtxqZQGxhgUyJQ+3T
	wGwWAVWJruO3GUFsXgFLiXv3P7NC2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhniUgWJHWdf
	M0IcYSWxt+0/M0SNiMS+F+8YQQ6SEPjKLnH58T52iGUCEt8mH2KBBIWsxKYDUHMkJQ6uuMEy
	gVFiFpLVs5CsnoVk9SwkKxYwsqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECIzn0/+eTdjB
	eO+A9SFGAQ5GJR7egr41IUKsiWXFlbmHGE2BLprILCWanA9MGnkl8YbGZkYWpiamxkbmlmZK
	4ryvpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDUDWqWlXzSaC2my/xtR0vanrC93238
	krKrlutN2HAq4NzWIoslVg/uOp/e93hVYE/VB+PkisulC858XLl+5VkBx+Y5Bj/VmNYGWOdp
	fbCv4VnEN9XpZU+DW63NFafEC+eezpn2dmr2Vy6FeQtTrrTM/1jxOOvxf7tpB/3jFadray/d
	tee6o/FXJZbijERDLeai4kQA3li9JuICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQV2xk2tCDBbc5rJYOvESs8W7z1UW
	W47dY7SYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGnbaXLAWr
	+CsaZ3eyNDCu4e5i5OSQEDCRWN8zgw3CFpO4cG89kM3FISQwnVHib+8FdgjnL6PEjcO9LF2M
	HBxsAtoSf7aIgjSICKhL3Jk3gQWkhlngE6PEwysHmEESQgLJEn/bPoFN5QTa8PBWIxOILSyQ
	KXGofRqYzSKgKtF1/DYjiM0rYClx7/5nVghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yQ1yq
	ILHj7GtGiCOsJPa2/WeGqBGR2PfiHeMERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRnC6eSe9gXNVgcYhRgINRiYe3oG9NiBBrYllxZe4hRgkOZiURXqtO
	oBBvSmJlVWpRfnxRaU5q8SFGU6BPJzJLiSbnA1NZXkm8obGJmZGlkbmhhZGxuZI4r5J9W4iQ
	QHpiSWp2ampBahFMHxMHp1QD42bucC31ih1iJyOv3deVfx/5MJlBoePypgippkm7sw7LCBsw
	PPaZ0VAT1a+8Obl206c9O/ZM6D+i1sf9V0Boxz5HsSt1+n4V7c7lx4U19W/+T1g878I8LZ8Z
	8nL3XijekLBteuL/7HL1SSe9K2vfhl587fI2okGp0EHwteSH3NXf360NcwvhUWIpzkg01GIu
	Kk4EAO//53QtAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
> > +
> > +	length=$(($BLOCKS * $BSIZE))
> > +	case $FSTYP in
> > +	xfs)
> > +	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
> > +	;;
> > +	ext4)
> > +	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
> > +	;;
> > +	esac
> 
> I think we typically try to define things like blocksize in the test
> configuration. The MKFS_OPTIONS env. var. can be defined with the
> correct options for the associated fs being tested. That eliminates the
> need to loop and for the fs-specific _scratch_mkfs calls above.
Okay, I will change.
> 
> > +	_scratch_mount >> $seqres.full 2>&1
> > +
> > +	# Write file
> > +	$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
> > +
> > +
> > +	# Insert alternate blocks
> 
> Trailing space in the above comment.
> 
> > +	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +		offset=$((($j*$BSIZE)*2))
> > +		$XFS_IO_PROG -c "finsert $offset $BSIZE" $testfile > /dev/null
> > +	done
> > +
> > +	# Check if 100 extents are present
> > +	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
> > +
> > +	_check_scratch_fs
> > +	if [ $? -ne 0 ]; then
> > +		status=1
> > +		exit
> > +	fi
> > +
> > +	# Collapse alternate blocks
> 
> ... and here as well.
Okay, I wil fix both points.
> 
> > +	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +		offset=$((($j*$BSIZE)))
> > +		$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
> > +	done
> > +
> > +	# Check if 1 extents are present
> > +	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
> > +
> > +	_check_scratch_fs
> > +	if [ $? -ne 0 ]; then
> > +		status=1
> > +		exit
> > +	fi
> > +
> 
> Maybe create a copy of the original file before we run through the
> insert and collapse sequence and cmp the files here as a last step?
Good idea. I will add your point.

Thanks for your review!
> 
> Brian

