Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbaGRIvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:51:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20444 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbaGRIvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:51:20 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-8c-53c8dff0975c
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dmitry Monakhov'" <dmonakhov@openvz.org>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>, xfs@oss.sgi.com,
        "=?UTF-8?Q?'Luk=C3=A1=C5=A1_Czerner'?=" <lczerner@redhat.com>
References: <004001cf9aa4$2670e280$7352a780$@samsung.com>
 <alpine.LFD.2.00.1407081558280.2180@localhost.localdomain>
 <87tx6ktiay.fsf@openvz.org>
In-reply-to: <87tx6ktiay.fsf@openvz.org>
Subject: RE: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
Date: Fri, 18 Jul 2014 17:50:55 +0900
Message-id: <002901cfa265$636d2e50$2a478af0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGrJOZNAI0ZuL5IevgT+zbvOhNoQAIW0xsrAQ2dXteb1UCJkA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42JZI2JSovvh/olgg82zxS2WTrzEbPHuc5XF
	lmP3GC1OzPS0OD1hEZPFsgebWSxmzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHb49QiCY/N
	K7Q8ms4cZfaYdPgzk8fqC1sZPd7vu8rm0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBlPnzaz
	FmwTq7hyeD1bA2OHUBcjJ4eEgInEtq9X2CBsMYkL99YD2VwcQgJLGSUWvmpi72JkBys6GwsR
	XsQo8fffelYI5y+jxJpZ0xm7GDk42AS0Jf5sEQWZIyKgI9F85RoLSA2zQCOzxNO7+5khGqYw
	SmzfcAGsgVNAQ2LC30qQBmEBW4npZ3czgtgsAqoSD/6sBzuIV8BS4vvF5cwQtqDEj8n3WEBs
	ZgF1iUnzFjFD2NoST95dYIV4QEFix9nXjBBHOEncO97PCFEjIrHvxTtGkBskBOZySMzt3MUO
	sUxA4tvkQywg90gIyEpsOsAMMUdS4uCKGywTGCVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILi
	pPQiQ73ixNzi0rx0veT83E2MwNg//e9Z7w7G2wesDzEmA62fyCwlmpwPTB15JfGGxmZGFqYm
	psZG5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAY+ap/u5QO+0EFlR8z
	ZmfVx0eLppQdOm8aWaK/JX/PZgkDuR0/5fRuuOyX+3nvy1mx70FOWftivR2WzLTmMM84Vlmw
	/q00s1W79rd/m3cUzEoXOqh80vf/2dPN8m/3LH8gbWlY8rtE7VXKg5+9UfNjRVxP+Gf6Pfn6
	Nmnh6sqIyb+f7GfreO6mxFKckWioxVxUnAgAtDCxrRMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAd0P908EG8zZzWexdOIlZot3n6ss
	thy7x2hxYqanxekJi5gslj3YzGIxc94dNos9e0+yWFzeNYfNorXnJ7vFor5bjA7cHqcWSXhs
	XqHl0XTmKLPHpMOfmTxWX9jK6PF+31U2j74tqxg9Pm+SC+CIamC0yUhNTEktUkjNS85PycxL
	t1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6U0mhLDGnFCgUkFhcrKRvh2lCaIib
	rgVMY4Sub0gQXI+RARpIWMOY8fRpM2vBNrGKK4fXszUwdgh1MbJzSAiYSJyN7WLkBLLEJC7c
	W8/WxcjFISSwiFHi77/1rBDOX0aJNbOmM3YxcnCwCWhL/NkiCtIgIqAj0XzlGgtIDbNAI7PE
	07v7mSEapjBKbN9wAayBU0BDYsLfSpAGYQFbielndzOC2CwCqhIP/oBs4+TgFbCU+H5xOTOE
	LSjxY/I9FhCbWUBdYtK8RcwQtrbEk3cXWCEuVZDYcfY1I8QRThL3jvczQtSISOx78Y5xAqPQ
	LCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4sz6R2MK5ssDjE
	KMDBqMTDa3HzeLAQa2JZcWXuIUYJDmYlEd7s+0Ah3pTEyqrUovz4otKc1OJDjKZAn05klhJN
	zgcmvbySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYw+J7OMmDde
	VElYcPbRfelOtxPrjONMqpeWZR63mhf44PaMY6WC6uE3LpjbFMZesZP7ybQ22/Vyyydlj9Vh
	5y+ZiN+NmnYk0M51z1LP1EBRXq5ts66cz1/UecDZoSl4lcm37OtbmR6+ezqrVVK84p/aswq7
	/StPPhbj1Tv4er7ogSz2qpKgzbOUWIozEg21mIuKEwHjaHz4QgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 8 Jul 2014 16:02:28 +0200 (CEST), Lukáš Czerner <lczerner@redhat.com> wrote:
> Non-text part: MULTIPART/MIXED
> > On Tue, 8 Jul 2014, Namjae Jeon wrote:
> >
> > > Date: Tue, 08 Jul 2014 21:00:02 +0900
> > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > > To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
> > > Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
> > >     linux-kernel@vger.kernel.org, Lukáš Czerner <lczerner@redhat.com>,
> > >     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>,
> > >     Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com
> > > Subject: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
> > >
> > > This patch implements fs ioctl's IOC_MOV_DATA for Ext4.
> >
> > Hmm isn't this basically what ext4_move_extents() does ? eg.
> > EXT4_IOC_MOVE_EXT ?
> >
> > I guess that the intention here is to do the move, without actually
> > moving the data right ? But nevertheless maybe some code can be
> > shared with ext4_move_extents() ?
> It definitely can be shared, because it has specific case for unwritten
> data see move_extent_per_page().
If I understand correctly, mov_extent_per_page calls mext_replace_branches to
_replace_ extents from 1 inode to other inode. Please correct me if I am wrong.
ioc_mov_data will not replace extents, but it will actually _move_ extents into
hole from donor to receiver, leaving a hole at the place from where extents are
moved.
Could you elaborate more how it can be shared for unwritten data case ?

> But I think we can observe another way to unify this two things.
> An idea inspired by the fact that ioc_move_data works only for
> regular inodes, where orig_offset == donor_offset. 
Could you elaborate this point? 

> This is showstopper
> for  my utility e4defrag2 ( new version of e4defrag which is able defragment
> pack small files as described here :
> http://lists.openwall.net/linux-ext4/2014/04/28/3)
> 
> Proposed API is very similar to ext4_ext_migrate:
> Args:
>   orig_file: inode which we want to defragment
>   donor_file: a file which will be used as a donor of blocks
> 1) fallocate big donor_file
> 2) a) Create tmp inode wich nlink = 0
>    b) move extents required extents from  donor to tmp_donor_inode
>    c) return file descriptor (tmp_fd) to that tmp_donor_inode
> 4) Mark orig_file's inode with EXT4_STATE_EXT_MIGRATE state
> 5) Copy data from orig_file to tmp_fd
> 6) IOC_SWAP_EX: atomically swap  orig_file->i_data and tmp_fd->i_data
>    if EXT4_STATE_EXT_MIGRATE was not cleared.
> 
> This approach can works not only for regular file w/o journaling
> enabled, but also for journaled ones, and directories.
> 
> 
> 
> 
> >
> > -Lukas
> >

