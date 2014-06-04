Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaFDE5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 00:57:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33381 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFDE5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 00:57:40 -0400
X-AuditID: cbfee68f-b7fef6d000003970-27-538ea741a452
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Theodore Ts'o'" <tytso@mit.edu>, "'Dave Chinner'" <david@fromorbit.com>
Cc: "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>,
        "=?UTF-8?Q?'Luk=C3=A1=C5=A1_Czerner'?=" <lczerner@redhat.com>
References: <003601cf6aa7$883103b0$98930b10$@samsung.com>
 <alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
 <000d01cf7ca3$98335c50$c89a14f0$@samsung.com>
 <alpine.LFD.2.00.1406021204540.2231@localhost.localdomain>
 <002201cf7e59$2e684c10$8b38e430$@samsung.com>
 <alpine.LFD.2.00.1406021450541.2231@localhost.localdomain>
 <20140602150258.GG30598@thunk.org>
In-reply-to: <20140602150258.GG30598@thunk.org>
Subject: RE: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Wed, 04 Jun 2014 13:57:37 +0900
Message-id: <000e01cf7fb1$814ab6d0$83e02470$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQOcBKJD5lk5ojpc7FDcCMzPaSWP+QCjXdQQAXmE8b8CRXdbEAIX9EgtAn5X6noBZB3wwJd0cicA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWyRsSkSNdxeV+wwdsjshZLJ15itthy7B6j
	xbIHm1ksZs67w2axZ+9JFovLu+awWbT2/GS3WNR3i9GBw+PUIgmPpjNHmT1WX9jK6PF+31U2
	j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4MrY9eIaU8FSwYqnx3kaGE/ydjFyckgImEjs/DWH
	CcIWk7hwbz1bFyMXh5DAUkaJ732fgRIcYEWvF6lCxBcxSny49B+q6C+jxPGZ71hBitgEtCX+
	bBEFGSQi4CnR9PIVO0gNs8ALRokpr66xQzR8ZZI4tPgRK0gVp4C+xMaPe8GahQX8JXas8wMJ
	swioSly6080MYvMKWEqs/dzBCGELSvyYfI8FxGYWUJeYNG8RM4StLfHk3QVWiA8UJHacfc0I
	cUSMxMxDh5kgakQk9r14xwhyg4TAX3aJaRP6mCCWCUh8m3yIBeJLWYlNB5gh5khKHFxxg2UC
	o8QsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGM+n/z3r38F4
	94D1IcZkoPUTmaVEk/OB6SCvJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTBOC/qgvMXFQ+6u+lZbXybXlbs+FezNv2ESrbT2kZNFyOK5e+4kS6Y9
	ijyzU77Pt4PPr3Oqrbr+2nnPVXzemXA7tPibGpx/r8PjfKXNu1WY4/ExqzTmuonKOo+410dm
	y+uqPfcOqY7c8n2OvM8T7ziZyts3ZdT3Rai/8DJ/KadgEhK4LNjgnxJLcUaioRZzUXEiAA9H
	N6P9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAV3H5X3BBu8bRC2WTrzEbLHl2D1G
	i2UPNrNYzJx3h81iz96TLBaXd81hs2jt+clusajvFqMDh8epRRIeTWeOMnusvrCV0eP9vqts
	Hn1bVjF6fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY9eLa0wF
	SwUrnh7naWA8ydvFyMEhIWAi8XqRahcjJ5ApJnHh3nq2LkYuDiGBRYwSHy79h3L+Mkocn/mO
	FaSBTUBb4s8WUZAGEQFPiaaXr9hBapgFXjBKTHl1jR2i4SuTxKHFj1hBqjgF9CU2ftwL1iws
	4C+xY50fSJhFQFXi0p1uZhCbV8BSYu3nDkYIW1Dix+R7LCA2s4C6xKR5i5ghbG2JJ+8usEJc
	qiCx4+xrRogjYiRmHjrMBFEjIrHvxTvGCYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzhZPJPewbiqweIQowAHoxIP74SbvcFCrIllxZW5hxglOJiVRHj1
	FvQFC/GmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MJHllcQbGpuYGVkamRtaGBmbkyasJM57
	sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjv5dXVm9K6tzXuY7XJ9xhuVgV+XO3WOWHybYCrBFS
	9ZNNj4mI9QQt2fN7BoeqxANNZXYL0XfMfyS897JuEBA9dWqzYusj+YhDQSs9GhXq1z6vzQo6
	fnfmZmmLQ39PmDz4c2EHX8CsuFWPP15c+MwrMf7m/+sfC21nzgyseW3F8Lqvu2nuYfHVSizF
	GYmGWsxFxYkAS0b23FoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jun 02, 2014 at 03:06:13PM +0200, Lukáš Czerner wrote:
> > > > So what will happen when there is not enough space when "inserting a
> > > > range" ? And how should user proceed from there ?
> > > If insert range fails with an ENOSPC error, user could use collapse
> > > range on the same range to remove the hole.
> > > And after freeing more space, he can again try inserting range.
> > > Ofcourse, this type of guidance should be properly documented in
> > > manpage. When updating fallocate(2) manpage, I will keep  in mind to
> > > describe ENOSPC handling.
> >
> > Why collapse ? The hole is already there right ? Why not just use
> > fallocate to allocate the space for the hole. And that's my point
> > actually. Why not do it this way in the first place, because this is
> > really counterintuitive.
> 
> It's worse than that.  It's possible that the reason why you got the
> ENOSPC warning was because the operation to move the extents down
> required allocating a block, and it was *that* block allocation which
> failed.  So it's not deterministic whether or not the file's extent
> mappings were modified after a ENOSPC error, and so it's not clear
> whether or not a collapse_range function will undo the range that had
> been inserted --- or whether it ends up deleting existing data blocks.
> 
> In generally, you really want system calls to have all-or-nothing
> effects, where if the system call returns an error, the state of the
> file has not been changed.  And for that reason, I agree with Lukáš
> that it is really a good idea to decouple moving the blocks down, and
> allocating space --- and to make sure that if there is any failure
> while inserting the range, the state of the file is not modified at all.
Okay, I will remove allocating space part in insert range patch.
But renaming flags as FALLOC_FL_INSERT_HOLE is needed to concent with
XFS people. Because Dave prefered to call it FALLOC_FL_INSERT_RANGE
so that it looks like it is related to collapse range.

Hi Dave.
Do you have any objection about renaming as insert hole ?

Thanks for opinions!

> 
> Cheers,
> 
> 					- Ted

