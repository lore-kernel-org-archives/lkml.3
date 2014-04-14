Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaDNBqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:46:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32018 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaDNBqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:46:17 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f566d000002344-7a-534b3de64bb1
Content-transfer-encoding: 8BIT
Message-id: <1397439855.24638.24.camel@kjgkr>
Subject: Re: [PATCH 0/7] f2fs: some fix and cleanup about flush_merge
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 14 Apr 2014 10:44:15 +0900
In-reply-to: <534B374C.8030009@cn.fujitsu.com>
References: <5347BAA5.6070104@cn.fujitsu.com> <534B374C.8030009@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zI91ntt7BBs1brCyetx9gtri0yN1i
	z96TLBaXd81hc2Dx+H9wErPH7gWfmTw+b5ILYI7isklJzcksSy3St0vgyvg7v5214BF3xcR7
	J5kaGOdydjFyckgImEjMeLGYFcIWk7hwbz1bFyMXh5DAMkaJvXNuscAV7VnACJFYxCixvucO
	O0iCV0BQ4sfke0BFHBzMAvISRy5lg4SZBdQlJs1bxAxR/4pR4tfvyUwQ9boSmy+vZwaxhQVc
	JdY/aWAF6WUT0JbYvN8AJCwkoCjxdv9dsINEBNQknr27xAQyh1mgm1Hi7PpXYHtZBFQlpnx/
	wwhicwroSez8OJENotlf4nvLXLBmfgFRicMLtzNDPKAksbu9kx1kkITAOXaJfVP+MkEMEpD4
	NvkQ2AMSArISmw5A1UtKHFxxg2UCo8QsJG/OQnhzFpI3FzAyr2IUTS1ILihOSi8y0itOzC0u
	zUvXS87P3cQIibi+HYw3D1gfYkwG2jiRWUo0OR8YsXkl8YbGZkYWpiamxkbmlmakCSuJ8y56
	mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZEhcqXi2+NiXLlbNi3PiTpTwWe8TOqsIf+H
	7t2ZS/+8r9J2XJV1+IDit6fNxsW+3ZUt7NnOM2WFViyQFVBoWR35S3Gak8syqQ5pxsnW208l
	7JzwK+Pm8b4Xet/W32lwWd1rnvjyrYfxmUcbd645megZZFl52Z/P7U+5R6OxVoeLZo7n9IVn
	JJRYijMSDbWYi4oTAWsrBFDOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd1ntt7BBifPmVk8bz/AbHFpkbvF
	nr0nWSwu75rD5sDi8f/gJGaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jxd347a8Ej7oqJ904yNTDO5exi5OSQEDCRmLFnASOELSZx4d56ti5GLg4h
	gUWMEut77rCDJHgFBCV+TL7H0sXIwcEsIC9x5FI2SJhZQF1i0rxFzBD1rxglfv2ezARRryux
	+fJ6ZhBbWMBVYv2TBlaQXjYBbYnN+w1AwkICihJv999lBbFFBNQknr27xAQyh1mgm1Hi7PpX
	YHtZBFQlpnx/A3Ycp4CexM6PE9kgmv0lvrfMBWvmFxCVOLxwOzPEA0oSu9s72ScwCs1CcvYs
	hLNnITl7ASPzKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgeH4mvYNxVYPFIUYBDkYlHt6E
	7Z7BQqyJZcWVuYcYJTiYlUR4t2V4BQvxpiRWVqUW5ccXleakFh9iTAY6fCKzlGhyPjDV5JXE
	GxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY3gq+3Wpq/8mMbV9
	/X/Kqfv1ynWXrm/ffmbt+Zl9tlaC0+9yfe6Y15JbMWUa79UpTisOxJrIvFMuOrXu2vSNl1bE
	2omvfaXfs7+4XSPi96X5rTuiSlMFn98LaTxXvZDzVGnY6R9fLnho/eg6LndDmT9Y9OLu+Gt6
	r5mqnrhN5Xn35M9hyX+H73EosRRnJBpqMRcVJwIAk97wbSsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

I just started to review the patches and merge them individually though.
Since I've been internally doing in my local tree, so that should be no
problem. I'll roll back to the latest point.
Anyway, thank you for your work. :)

2014-04-14 (월), 09:18 +0800, Gu Zheng:
> Hi All,
> There seems to be a mistake in "[PATCH 2/7]f2fs: remove the unuseful "issue_tail" list",
> and the whole patchset needs to be reworked. So please ignore this one.
> Sorry for the noise.
> 
> Regards,
> Gu
> On 04/11/2014 05:49 PM, Gu Zheng wrote:
> 
> > Gu Zheng (7):
> >   f2fs: put the bio when issue_flush completed
> >   f2fs: remove the unuseful "issue_tail" list
> >   f2fs: use __GFP_ZERO to avoid appending set-NULL
> >   f2fs: enable flush_merge only in f2fs is not read-only
> >   f2fs: add the flush_merge handle in the remount flow
> >   f2fs: introduce struct flush_cmd_control to wrap the flush_merge
> >     fields
> >   f2fs: introduce help function {create,destroy}_flush_cmd_control
> > 
> >  fs/f2fs/f2fs.h    |   17 ++++++---
> >  fs/f2fs/segment.c |  102 +++++++++++++++++++++++++++++++++++-----------------
> >  fs/f2fs/super.c   |   32 ++++++++++++++--
> >  3 files changed, 107 insertions(+), 44 deletions(-)
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung

