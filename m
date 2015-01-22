Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbbAVIww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:52:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46601 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbAVIwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:52:24 -0500
X-AuditID: cbfee691-f79b86d000004a5a-78-54c0ba45e25c
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Michael Kerrisk'" <mtk.manpages@gmail.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'Linux-Fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
        bfoster@redhat.com, "'Linux API'" <linux-api@vger.kernel.org>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>
References: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
 <CAHO5Pa3HnzP=KcBQOWDEkBqppMGXJ2kzfNKj21ruQ5SvWnms2g@mail.gmail.com>
In-reply-to: <CAHO5Pa3HnzP=KcBQOWDEkBqppMGXJ2kzfNKj21ruQ5SvWnms2g@mail.gmail.com>
Subject: RE: [PATCH v9 0/11] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Thu, 22 Jan 2015 17:52:21 +0900
Message-id: <003901d03620$bbf4a450$33ddecf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFeEwaBS0Q8AoICLdMysUUZS5e1ywHvF6+KnaCheVA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkSNd114EQg6lPtS2WTrzEbPHuc5XF
	lmP3GC2u373FbLH5ewebxcx5d9gs9uw9yWJxedccNotTEx6wW7T2/GS3WNR3i9GB2+PUIgmP
	nbPusns0nTnK7LH6wlZGj/f7rrJ59G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8bRnfsZC65I
	VKxcPIu9gfGKcBcjJ4eEgInEhlPdrBC2mMSFe+vZuhi5OIQEljJK7Lh/EijBAVa07n0dSI2Q
	wCJGiaXbEiBq/jJKPHk0nxGkhk1AW+LPFlGQGhEBPYkLb8+wgNQwC9xgkvj8cQYTREMXo8SS
	2dvZQKo4BYIlbjdOYASxhQX8Jfa+/coCYrMIqEocvnIZzOYVsJRYsuIwlC0o8WPyPRaQZcwC
	6hJTpuSChJkF5CU2r3nLDPGAgsSOs68ZIY6wkuifdZEVokZEYt+Ld4wgN0gIzOSQWLpzOzvE
	LgGJb5MPsUA8KSux6QDUHEmJgytusExglJiFZPMshM2zkGyehWTDAkaWVYyiqQXJBcVJ6UWm
	esWJucWleel6yfm5mxiBMX/637OJOxjvH7A+xCjAwajEw5tRfCBEiDWxrLgy9xCjKdBBE5ml
	RJPzgYklryTe0NjMyMLUxNTYyNzSTEmcV0f6Z7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	RpOl50sdjv/7v/ptSvbpV8+9JgakRIU2BnjOiV31Zn/HBtPkFHamduskM+Wpmo8mvPDjEmPS
	3uAeUbUo9lo34zLj9pW3hf+6XfpVnM2xdO60vJ9O4ZcmL15z1YPxqd3tozePuURIPKzh1tDl
	idv6b+FsWdvmoB+OmecmLxdtWRGmzXB3nuEBeSWW4oxEQy3mouJEANHjB630AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAV3XXQdCDL5uVbJYOvESs8W7z1UW
	W47dY7S4fvcWs8Xm7x1sFjPn3WGz2LP3JIvF5V1z2CxOTXjAbtHa85PdYlHfLUYHbo9TiyQ8
	ds66y+7RdOYos8fqC1sZPd7vu8rm0bdlFaPH501yAexRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA3KimUJeaUAoUCEouLlfTtME0IDXHTtYBp
	jND1DQmC6zEyQAMJaxgzju7cz1hwRaJi5eJZ7A2MV4S7GDk4JARMJNa9r+ti5AQyxSQu3FvP
	BmILCSxilFi6LaGLkQvI/sso8eTRfEaQejYBbYk/W0RBakQE9CQuvD3DAlLDLHCDSeLzxxlM
	EA1djBJLZm8Hm8QpECxxu3ECI4gtLOAvsfftVxYQm0VAVeLwlctgNq+ApcSSFYehbEGJH5Pv
	sYAsYxZQl5gyJRckzCwgL7F5zVtmiEMVJHacfc0IcYSVRP+si6wQNSIS+168Y5zAKDQLyaRZ
	CJNmIZk0C0nHAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBCeWZ1A7GlQ0WhxgFOBiV
	eHgzig+ECLEmlhVX5h5ilOBgVhLh3bkBKMSbklhZlVqUH19UmpNafIjRFOjPicxSosn5wGSX
	VxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA6BVSn7xi5RLTLVqf
	hC/cKGN/N+V+8dXE4zv9ls9NOXBsdunSGbYLfj2Ypa9vfdeSe2VfHW9Rd9sfObvY+qsOCrvZ
	p/5O9Dbde/rs7TWXrq1XfdT4d0aq0Wrm49w7Hs7z+F2+W3bG/f6aansnPkVNBXHF95bTU4L+
	7j2159rjG9cLy9dMypg4IUKJpTgj0VCLuag4EQDX5DSbPgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [CC += linux-api]
> 
> Hello Namjae
> 
> Please, all patches such as this that touch the user-space ABI must CC
> linux-api@. (The kernel source file Documentation/SubmitChecklist
> notes that all Linux kernel patches that change userspace interfaces
> should be CCed to linux-api@vger.kernel.org.  See also
> https://www.kernel.org/doc/man-pages/linux-api-ml.html )
Hi Michael,

I will keep that in mind.
Thank you!

> 
> Thanks,
> 
> Michael
> 
> 
> On Wed, Jan 21, 2015 at 4:11 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > In continuation of the work of making the process of non linear editing of
> > media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> > for fallocate.
> >
> > This flag will work opposite to the FALLOC_FL_COLLAPSE_RANGE flag.
> > As such, specifying FALLOC_FL_INSERT_RANGE flag will create new space inside file
> > by inserting a hole within the range specified by offset and len.
> > User can write new data in this space. e.g. ads.
> > Like collapse range, currently we have the limitation that offset and len should
> > be block size aligned for both XFS and Ext4.
> >
> > The semantics of the flag are :
> > 1) It creates space within file by inserting a hole of  len bytes starting
> >    at offset byte without overwriting any existing data. All the data blocks
> >    from offset to EOF are shifted towards right to make hole space.
> > 2) It should be used exclusively. No other fallocate flag in combination.
> > 3) Offset and length supplied to fallocate should be fs block size aligned
> >    in case of xfs and ext4.
> > 4) Insert range does not work for the case when offset is overlapping/beyond
> >    i_size. If the user wants to insert space at the end of file they are
> >    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> > 5) It increses the size of file by len bytes.
> >
> >
> > Namjae Jeon (11):
> >  fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  xfsprogs: xfs_io: add finsert command for insert range via fallocate
> >  xfstests: generic/039: Standard insert range tests
> >  xfstests: generic/040: Delayed allocation insert range
> >  xfstests: generic/041: Multi insert range tests
> >  xfstests: generic/042: Delayed allocation multi insert
> >  xfstests: generic/043: Test multiple fallocate insert/collapse range calls
> >  xfstests: fsstress: Add fallocate insert range operation
> >  xfstests: fsx: Add fallocate insert range operation
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> --
> Michael Kerrisk Linux man-pages maintainer;
> http://www.kernel.org/doc/man-pages/
> Author of "The Linux Programming Interface", http://blog.man7.org/

