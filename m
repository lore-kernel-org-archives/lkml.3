Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3EOWHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:07:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28971 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3EOWHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:07:36 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-f3-519407251c73
Date: Wed, 15 May 2013 22:07:33 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: Question about ext4 excessive stall time
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "dmonakhov@openvz.org" <dmonakhov@openvz.org>,
        "gnehzuil.liu@gmail.com" <gnehzuil.liu@gmail.com>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130515220515235@eunb.song
Msgkey: 20130515220515235@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130515220515235@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17112733.237501368655652616.JavaMail.weblogic@epv6ml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zlq4q+5RAg/P3DS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGyuWPWQu61Cp27l/K0sDYodrFyMkhJKAi0fL/OyOILSFgIrF9
	/UEoW0ziwr31bF2MXEA1yxglnm6dx97FyAFW9GxSJER8PqPEl/V3WEAaWARUJbZtgrDZBLQl
	3n55wApiCwtYSjw7vxHMFhFQllg1cxMTiM0s0Mok8WVhEcQR8hKTT19mB7F5BQQlTs58wgJx
	hJJEx6HDjBBxZYmJsw6wQcQlJGZNv8AKYfNKzGh/ClUvJzHt6xpmCFta4vysDXDPLP7+GCrO
	L3Hs9g4miF94JZ7cD4YZs3vzF6jxAhJTz4DCAaREXeLfzhCIMJ/EmoVvWWCm7Dq1nBmm9f6W
	uVBfKUpM6X7IDmFrSXz5sY8N3Ve8Ai4SHUenM09gVJ6FJDULSfssJO3IahYwsqxiFE0tSC4o
	TkovMtQrTswtLs1L10vOz93ECEkKvTsYbx+wPsSYDIyRicxSosn5wKSSVxJvaGxmZGFqYmps
	ZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGJ52XF1Zo7Nftn31zu0JD
	Vsr1jZPf75ZW5Fv0KubpTj61G2HHf6ZPeiDIVqfx3pTLOXnav4ru3sP5Orelnu7pPvP1t+GK
	erPIf202Ic9ldghlCWauN1s5UahTMyPw0D5GNtuX2RHbNDpWnN569mijVe38vYk9jGaTstXs
	7ON37vRKSyvOO+KpxFKckWioxVxUnAgAU9q21yADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DF1V9imBBrPn6Flc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jJXLH7MWdKlV7Ny/lKWBsUO1i5GTQ0hARaLl/3fGLkYODgkBE4lnkyJBwhICYhIX7q1n62Lk
	AiqZzyjxZf0dFpAEi4CqxLZNEDabgLbE2y8PWEFsYQFLiWfnN4LZIgLKEqtmbmICsZkFWpkk
	viwsgtglLzH59GV2EJtXQFDi5MwnLBDLlCQ6Dh1mhIgrS0ycdYANIi4hMWv6BVYIm1diRvtT
	qHo5iWlf1zBD2NIS52dtYIQ5evH3x1Bxfoljt3cwQfzFK/HkfjDMmN2bv0CNF5CYeuYg1Ovq
	Ev92hkCE+STWLHzLAjNl16nlzDCt97fMhfpKUWJK90N2CFtL4suPfWzovuIVcJHoODqdeQKj
	3CwkqVlI2mchaUdWs4CRZRWjaGpBckFxUnqFiV5xYm5xaV66XnJ+7iZGcHp6tmQHY8MF60OM
	AhyMSjy8E2ZODhRiTSwrrsw9xCjBwawkwpvzHSjEm5JYWZValB9fVJqTWnyIMRkYfxOZpUST
	84GpM68k3tDYwNjQ0NLcwNTQyII0YSVx3met1oFCAumJJanZqakFqUUwW5g4OKUaGCXDVS9+
	W37PPeA7Z3+X8lKfgheZApLu3G9v1xa/Sjng2hB81urymtuFXGveMaTXXAyU+sPeWfC6QqhG
	eacXt77F/tVxx9u+TJ3nkOd8vHTq/vWus/9/rw0Iz5UujucVr4hyarv8vz2Qu8tFNmNX9XFG
	ozPre9i52hOsdQNLrSt2qK51ePFXiaU4I9FQi7moOBEASX/8WZMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4FM7kii018253


> On Wed, May 15, 2013 at 07:15:02AM +0000, EUNBONG SONG wrote:
> > I know my kernel version is so old. I just want to know why this
> > problem is happened.  Because of my kernel version is old? or
> > Because of disk ?,, If anyone knows about this problem, Could you
> > help me?

> So what's happening is this.  The CFQ I/O scheduler prioritizes reads
> over writes, since most reads are synchronous (for example, if the
> compiler is waiting for the data block from include/unistd.h, it cant
> make forward progress until it receives the data blocks; there is an
> exception for readahead blocks, but those are dealt with at a low
> priority), and most writes are synchronous (since they are issued by
> the writeback daemons, and unless we are doing an fsync, no one is
> waiting for them).
>
> The problem comes when a metadata block, usually one which is shared
> across multiple files is undergoing writeback, such as an inode table
> block or a allocation bitmap block.  The write gets issued as a low
> priority I/O operation.  Then during the the next jbd2 transaction,
> some userspace operation needs to modify that metadata block, and in
> order to do that, it has to call jbd2_journal_get_write_access().  But
> if there is heavy read traffic going on, due to some other process
> using the disk a lot, the writeback operation may end up getting
> starved, and doesn't get acted on for a very long time.
>
> But the moment a process called jbd2_journal_get_write_access(), the
> write has effectively become one which is synchronous, in that forward
> progress of at least one process is now getting blocked waiting for
> this I/O to complete, since the buffer_head is locked for writeback,
> possibly for hundreds or thousands of milliseconds, and
> jbd2_journal_get_write_access() can not proceed until it can get the
> buffer_head lock.
>
> This was discussed at least month's Linux Storage, File System, and MM
> worksthop.  The right solution is to for lock_buffer() to notice if
> the buffer head has been locked for writeback, and if so, to bump the
> write request to the head of the elevator.  Jeff Moyer is looking at
> this.
>
> The partial workaround which will be in 3.10 is that we're marking all
> metadata writes with REQ_META and REQ_PRIO.  This will cause metadata
> writebacks to be prioritized at the same priority level as synchrnous
> reads.  If there is heavy read traffic, the metadata writebacks will
> still be in competition with the reads, but at least they will
> complete.
>
> Once we get priority escalation (or priority inheritance, because what
> we're seeing here is really a classic priority inversion problem),
> then it would make sense for us to no longer set REQ_PRIO for metadata
> writebacks, so the metadata writebacks only get prioritized when they
> are blocking some process from making forward progress.  (Doing this
> will probably result in a slight performance degradation on some
> workloads, but it will improve others with a heavy read traffic and
> minimal writeback interference.  We'll want to benchmark what
> percentage of metadata writebacks require getting bumped to the head
> of the line, but I suspect it will be the right choice.)
>
> If you want to try to backport this workaround to your older kernel,
> please see commit 9f203507ed277.


Hi, Ted.
I appreciate for your fantastic explanation. It's really great and very helpful for me.
Now i can understand about this issue thanks to you.

Thanks!
EunBong

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
