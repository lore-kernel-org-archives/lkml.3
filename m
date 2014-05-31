Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaEaHke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 03:40:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56966 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaEaHkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 03:40:32 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-1f-5389876decc0
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?=" <lczerner@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
References: <003601cf6aa7$883103b0$98930b10$@samsung.com>
 <alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
Subject: RE: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Sat, 31 May 2014 16:40:29 +0900
Message-id: <000d01cf7ca3$98335c50$c89a14f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQOcBKJD5lk5ojpc7FDcCMzPaSWP+QCjXdQQl7whiGA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsWyRsSkSDe3vTPYYOEVeYulEy8xW2w5do/R
	YtmDzSwWM+fdYbPYs/cki8XlXXPYLFp7frJbLOq7xejA4XFqkYRH05mjzB6rL2xl9Hi/7yqb
	R9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGXMXNzNXnBBuaKp5wRzA+M0mS5GTg4JAROJ7e0/
	2SFsMYkL99azdTFycQgJLGWUuH58LTtM0Zlt58FsIYFFjBIX9tlC2H8ZJSb95+9i5OBgE9CW
	+LNFFCQsImAnMXdOCxPIHGaBT4wS5/tes0HUl0l0z70HNodTwF3i38KV7CC9wgL+EjvW+YGE
	WQRUJQ48mMIMYvMKWErMmbSfEcIWlPgx+R4LSDmzgI7E10kRIGFmAXmJzWveMkNcqSCx4+xr
	RogTrCQuzX3KDFEjIrHvxTtGiJqf7BJT75VCrBKQ+Db5ENhICQFZiU0HoMZIShxccYNlAqPE
	LCSLZyEsnoVk8SwkCxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECIzj0/+eTdzBeP+A
	9SHGZKDtE5mlRJPzgWkgryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoYu5nu9KQmxGZ9sLzWXljyOszn2v5zO6UZ5+RJK2bXHJBJdJqWYtO47OKu
	dmPF59OSzkZL50uqZ38TP6a4/tVi1t9FfHc8C2NPLdCaXXHw6MWJyVXdvx4EHnj+7L+vQ09d
	im94QOjqzxuPyGZ/8HGX3bIjmtPfU2TJwcTzfHuLHI/PeT3VkX2XEktxRqKhFnNRcSIAIMmA
	NPkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd3c9s5gg87JYhZLJ15itthy7B6j
	xbIHm1ksZs67w2axZ+9JFovLu+awWbT2/GS3WNR3i9GBw+PUIgmPpjNHmT1WX9jK6PF+31U2
	j74tqxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVV
	cvEJ0HXLzAE6SEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYMXNxN3vB
	BeWKpp4TzA2M02S6GDk5JARMJM5sO88OYYtJXLi3ng3EFhJYxChxYZ8thP2XUWLSf/4uRg4O
	NgFtiT9bREHCIgJ2EnPntDB1MXJxMAt8YpQ43/caqrdMonvuPbCZnALuEv8WrmQH6RUW8JfY
	sc4PJMwioCpx4MEUZhCbV8BSYs6k/YwQtqDEj8n3WEDKmQV0JL5OigAJMwvIS2xe85YZ4koF
	iR1nXzNCnGAlcWnuU2aIGhGJfS/eMU5gFJqFZNIshEmzkEyahaRjASPLKkbR1ILkguKk9Fwj
	veLE3OLSvHS95PzcTYzgNPFMegfjqgaLQ4wCHIxKPLwLFnYEC7EmlhVX5h5ilOBgVhLhlazr
	DBbiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGAKyyuJNzQ2MTOyNDI3tDAyNidNWEmc92Cr
	daCQQHpiSWp2ampBahHMFiYOTqkGRp+mn9LTI478XC1XHtVUt9dIecY7p8sWeYfaWFnVfuhb
	dbEs/D+1VCo1SfLT7gvFwScWr3VgKFlQ23zHJP2Wpajd/8eJuUxTqsM3pP/+9OOw/cnaZl+G
	uzsmSv3Nj11utr4i50XctJ2X9ySvd1zx8vpnxZmdlwMkd9yJXXlq84eSnZLTm1NKOJRYijMS
	DbWYi4oTATsEEN9XAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > Date: Thu, 08 May 2014 19:23:19 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
> > Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
> >     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> >     Ashish Sangwan <a.sangwan@samsung.com>
> > Subject: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
> >
> > In continuation of the work of making the process of non linear editing of
> > media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> > for fallocate.
> >
> > This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
> > As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
> > in between the file within the range specified by offset and len. User can
> > write new data in this space. e.g. ads.
> > Like collapse range, currently we have the limitation that offset and len should
> > be block size aligned for both XFS and Ext4.
> >
> > The semantics of the flag are :
> > 1) It allocates new zeroed out on disk space of len bytes starting
> >    at offset byte without overwriting any existing data. All the data blocks
> >    from offset to EOF are shifted towards right to make space for inserting
> >    new blocks
> 
> Hi,
> 
> this sounds a little bit weird to me. I understand the reason for
> this, but this is effectively two operations masking as one. We
> shift the existing data and then we allocate unwritten extents for
> the hole we've created.
> 
> What would make more sense to me is to implement only the first
> operation - the shift. And then let the user to allocate unwritten
> extents for the hole using simple fallocate.
> 
> The reason is that if you succeed the first part and then fail the
> second due to ENOSPC or any other reason the file will end up in
> undefined state unnecessarily. Yes in your current implementation
> it seems that you'll always end up with the hole in the file and the
> rest is properly shifted, but that may vary from file system to file
> system. Some might choose to roll back the shift, some might not.
> 
> If FALLOC_FL_INSERT_RANGE (or any name you wish to choose) would
> just simply shift the extents then you'll get rid of this and the
> only thing that user needs to do (if he chooses to) is to use
> fallocate for the hole created by the shift. If it fails, then
> well, he can try again without any consequences. As a bonus you get
> the possibility to leave the hole in the file which might be useful
> as well.
> 
> With current behaviour this might get very confusing very quickly.
> 
> What do you and others think ?
Hi Lukas.
Insert range inherently means inserting a real range of space into
the file to provide guaranteed space with user in the inserted area
so that further writes should not fail with an -ENOSPC at least.
If insert range cannot gurantees the above semantics, It should
return error to user space.

If insert range has been performed on a file, It will reserve space
that write never fail in the inserted area,
In case of full partition or small available size than the range
user want, It seems odd just only left inserting a hole in the middle
of file and return success to user when no one can really write to
this hole.

Thanks!
> 
> Thanks!
> -LUkas
> 
> 
> > 2) It should be used exclusively. No other fallocate flag in combination.
> > 3) Offset and length supplied to fallocate should be fs block size aligned
> >    in case of xfs and ext4.
> > 4) Insert range does not work for the case when offset is overlapping/beyond
> >    i_size. If the user wants to allocate space at the end of file they are
> >    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> > 5) It increses the size of file by len bytes.
> >
> >
> > Namjae Jeon (10):
> >  fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  xfsprogs: xfs_io: add finsert command for insert range via fallocate
> >  xfstests: generic/027: Standard insert range tests
> >  xfstests: generic/028: Delayed allocation insert range
> >  xfstests: generic/029: Multi insert range tests
> >  xfstests: generic/030: Delayed allocation multi insert
> >  xfstests: fsstress: Add fallocate insert range operation
> >  xfstests: fsx: Add fallocate insert range operation
> >
> >

