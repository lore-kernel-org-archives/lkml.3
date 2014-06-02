Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaFBLw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:52:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20463 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaFBLwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:52:54 -0400
X-AuditID: cbfee690-b7fb56d000003439-db-538c65934f20
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?=" <lczerner@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
References: <003601cf6aa7$883103b0$98930b10$@samsung.com>
 <alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
 <000d01cf7ca3$98335c50$c89a14f0$@samsung.com>
 <alpine.LFD.2.00.1406021204540.2231@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.1406021204540.2231@localhost.localdomain>
Subject: RE: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 02 Jun 2014 20:52:51 +0900
Message-id: <002201cf7e59$2e684c10$8b38e430$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQOcBKJD5lk5ojpc7FDcCMzPaSWP+QCjXdQQAXmE8b8CRXdbEJehkH8A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWyRsSkQHdyak+wwe+JKhZLJ15itthy7B6j
	xbIHm1ksZs67w2axZ+9JFovLu+awWbT2/GS3WNR3i9GBw+PUIgmPpjNHmT1WX9jK6PF+31U2
	j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mo429PNWPDEtmLhzOVsDYy/9bsYOTkkBEwkPh/7
	ygphi0lcuLeerYuRi0NIYCmjxPP7h1hhirYsameBSCxilHjwYh8rhPOXUeLw4hVALRwcbALa
	En+2iII0iAjYScyd08IEUsMs8IlR4nzfa6ixjxkles+fBhvLKeAuMfHLFCaQZmEBf4kd6/xA
	wiwCqhKrHn1jBLF5BSwlPhw8wQ5hC0r8mHyPBaScWUBH4uukCJAwM9DaJ+8uQB2qILHj7GtG
	iBvcJI5uecoKUSMise/FO0aQEyQE/rJLtE9pYYTYJSDxbfIhsJkSArISmw4wQ8yRlDi44gbL
	BEaJWUg2z0LYPAvJ5llINixgZFnFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERjPp/89m7CD
	8d4B60OMyUDbJzJLiSbnA9NBXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtS
	i+KLSnNSiw8xMnFwSjUwpmiY7J8mo2Cy/Vn8RV6eXA7DRQ8Z1TbNZRAvP9oauTskX/vmA+XV
	ialBXjq2i24/uilYo6Z7VXXZ4pfpv6cdNmpf9r16UcydbZxfuzaKONj4ZGoqrVKu1Dyo4Cd4
	kneybmrLZ8nPQT7chXON/WrO9Mg/np6gV/NHWXrXvPv9xh8VlfkzGYOVWIozEg21mIuKEwGJ
	xq6+/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAd3JqT3BBk9OS1osnXiJ2WLLsXuM
	FssebGaxmDnvDpvFnr0nWSwu75rDZtHa85PdYlHfLUYHDo9TiyQ8ms4cZfZYfWEro8f7fVfZ
	PPq2rGL0+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxtmebsaC
	J7YVC2cuZ2tg/K3fxcjJISFgIrFlUTsLhC0mceHeerYuRi4OIYFFjBIPXuxjhXD+MkocXrwC
	KMPBwSagLfFniyhIg4iAncTcOS1MIDXMAp8YJc73vYbqfswo0Xv+NCtIFaeAu8TEL1OYQJqF
	BfwldqzzAwmzCKhKrHr0jRHE5hWwlPhw8AQ7hC0o8WPyPRaQcmYBHYmvkyJAwsxAa5+8u8AK
	caiCxI6zrxkhbnCTOLrlKStEjYjEvhfvGCcwCs1CMmkWwqRZSCbNQtKxgJFlFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZwsngmtYNxZYPFIUYBDkYlHt6f6j3BQqyJZcWVuYcYJTiYlUR4
	l1oAhXhTEiurUovy44tKc1KLDzEmA/05kVlKNDkfmMjySuINjU3MjCyNzA0tjIzNSRNWEuc9
	0GodKCSQnliSmp2aWpBaBLOFiYNTqoGx4pLnv1czLVdxqL9Pafz+raXhcZ+BznfxoNYwTTfJ
	v5FPFW5PkmmZH+f0xehl7ab+iRv3efPX7dj6xJ5v79NHNt0moRpVy8P+suZ9L1stt2WG0rVz
	sl/v2TtWr3rgbn4/u7judvHqKoW9DAtyGFIsDUyWm37sYTx8Tu2Xzby5W3Mzr6i6uYgpsRRn
	JBpqMRcVJwIAo9SKYloDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Date: Sat, 31 May 2014 16:40:29 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: 'Luká¹ Czerner' <lczerner@redhat.com>
> > Cc: 'Dave Chinner' <david@fromorbit.com>, 'Theodore Ts'o' <tytso@mit.edu>,
> >     'linux-ext4' <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
> >     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> >     'Ashish Sangwan' <a.sangwan@samsung.com>
> > Subject: RE: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for
> >     fallocate
> >
> >
> > > > Date: Thu, 08 May 2014 19:23:19 +0900
> > > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > > > To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
> > > > Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
> > > >     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> > > >     Ashish Sangwan <a.sangwan@samsung.com>
> > > > Subject: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
> > > >
> > > > In continuation of the work of making the process of non linear editing of
> > > > media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> > > > for fallocate.
> > > >
> > > > This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
> > > > As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
> > > > in between the file within the range specified by offset and len. User can
> > > > write new data in this space. e.g. ads.
> > > > Like collapse range, currently we have the limitation that offset and len should
> > > > be block size aligned for both XFS and Ext4.
> > > >
> > > > The semantics of the flag are :
> > > > 1) It allocates new zeroed out on disk space of len bytes starting
> > > >    at offset byte without overwriting any existing data. All the data blocks
> > > >    from offset to EOF are shifted towards right to make space for inserting
> > > >    new blocks
> > >
> > > Hi,
> > >
> > > this sounds a little bit weird to me. I understand the reason for
> > > this, but this is effectively two operations masking as one. We
> > > shift the existing data and then we allocate unwritten extents for
> > > the hole we've created.
> > >
> > > What would make more sense to me is to implement only the first
> > > operation - the shift. And then let the user to allocate unwritten
> > > extents for the hole using simple fallocate.
> > >
> > > The reason is that if you succeed the first part and then fail the
> > > second due to ENOSPC or any other reason the file will end up in
> > > undefined state unnecessarily. Yes in your current implementation
> > > it seems that you'll always end up with the hole in the file and the
> > > rest is properly shifted, but that may vary from file system to file
> > > system. Some might choose to roll back the shift, some might not.
> > >
> > > If FALLOC_FL_INSERT_RANGE (or any name you wish to choose) would
> > > just simply shift the extents then you'll get rid of this and the
> > > only thing that user needs to do (if he chooses to) is to use
> > > fallocate for the hole created by the shift. If it fails, then
> > > well, he can try again without any consequences. As a bonus you get
> > > the possibility to leave the hole in the file which might be useful
> > > as well.
> > >
> > > With current behaviour this might get very confusing very quickly.
> > >
> > > What do you and others think ?
> > Hi Lukas.
> > Insert range inherently means inserting a real range of space into
> > the file to provide guaranteed space with user in the inserted area
> > so that further writes should not fail with an -ENOSPC at least.
> > If insert range cannot gurantees the above semantics, It should
> > return error to user space.
> 
> So what will happen when there is not enough space when "inserting a
> range" ? And how should user proceed from there ?
If insert range fails with an ENOSPC error, user could use collapse
range on the same range to remove the hole.
And after freeing more space, he can again try inserting range.
Ofcourse, this type of guidance should be properly documented in
manpage. When updating fallocate(2) manpage, I will keep  in mind to
describe ENOSPC handling.
> 
> >
> > If insert range has been performed on a file, It will reserve space
> > that write never fail in the inserted area,
> > In case of full partition or small available size than the range
> > user want, It seems odd just only left inserting a hole in the middle
> > of file and return success to user when no one can really write to
> > this hole.
> 
> There is a fallocate for allocation, so as I already said you can
> shift the extents to make a hole in the file and then use fallocate
> to allocate space for it and you'll get the same result. You are
> basically doing that now as well, but when the allocation fails the
> whole "insert range" ioct fails, however the extents are already
> shifter and there is already a holi in the file so freeing some
> space and running this ioctl again will not help you at all. While
> if you fail a fallocate, you can free some space and run it again
> without any problems. The result will be as expected.
> 
> What I am arguing about is basically that your insert range ioct is
> masking two operations as one. Why not to make it transparent and
> split it into "shift extents" and fallocate ? Then there is a
> question about the name because it's no longer "insert range" but
> rather "insert hole" which I think is better and arguably more
> useful semantic.
The same thoeory can be argued against collapse range semantics too.
One can argue that collapse range should not remove any data blocks
from the specified range as that can be done by punch hole, so user
should first perform punch hole and then call collapse range to
eliminate the hole.
There are 2 reasons I make insert range to allocate space.
One is to keep insert range behavior as exactly opposite of
the collapse range and it is named as such so that it seems obvious
that it is related with collapse range.
Other one is that,  there will always be need of allocating space for
data  after making hole.  So doing this within insert range is saving
user from making 1 extra sys call.
That said, I agree with you that it is arguable and I am not biased
to this behavior.
Probably, need some more thoughts from other fs people.

Thanks for your opinion!

> 
> Thanks!
> -Lukas
> 
> >
> > Thanks!
> > >
> > > Thanks!
> > > -LUkas
> > >
> > >
> > > > 2) It should be used exclusively. No other fallocate flag in combination.
> > > > 3) Offset and length supplied to fallocate should be fs block size aligned
> > > >    in case of xfs and ext4.
> > > > 4) Insert range does not work for the case when offset is overlapping/beyond
> > > >    i_size. If the user wants to allocate space at the end of file they are
> > > >    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> > > > 5) It increses the size of file by len bytes.
> > > >
> > > >
> > > > Namjae Jeon (10):
> > > >  fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> > > >  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> > > >  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
> > > >  xfsprogs: xfs_io: add finsert command for insert range via fallocate
> > > >  xfstests: generic/027: Standard insert range tests
> > > >  xfstests: generic/028: Delayed allocation insert range
> > > >  xfstests: generic/029: Multi insert range tests
> > > >  xfstests: generic/030: Delayed allocation multi insert
> > > >  xfstests: fsstress: Add fallocate insert range operation
> > > >  xfstests: fsx: Add fallocate insert range operation
> > > >
> > > >
> >
> >

