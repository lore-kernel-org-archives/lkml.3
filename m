Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3ELNFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 09:05:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11485 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3ELNFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 09:05:03 -0400
X-AuditID: cbfee691-b7fef6d000002d62-f5-518f937c186f
Date: Sun, 12 May 2013 13:05:00 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: Re: EXT4 regression caused 4eec7
To: "Theodore Ts'o" <tytso@mit.edu>, Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jan Kara <jack@suse.cz>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130512130252322@eunb.song
Msgkey: 20130512130252322@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130512094125781@eunb.song
X-ParentMTR: 20130512094125781@eunb.song
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <31302271.2821368363898561.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zXd2ayf2BBnuX6lpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MLVtfMRWsEqz4dPgmUwPjG4EuRk4OIQEViZb/3xlBbAkBE4kj
	5+4xQdhiEhfurWfrYuQCqlnGKHH36go2uKJZE5khEvMZJTraV7CAJFgEVCVObPvHCmKzCWhL
	vP3yAMwWFjCUePL4FjOILSLgLzHh4XQWkGZmgX+MEjum/2WHOENeYvLpy2A2r4CgxMmZT1gg
	tilJNH36xgQRV5aY8mYz1HkSErOmX2CFsHklZrQ/haqXk5j2dQ0zhC0tcX7WBkaYdxZ/fwwV
	55c4dnsH0BwOsN4n94Nhxuze/AXqSQGJqWcOQrWqS8xdOBlqlaZE3/LlcGN2nYKxeSXub5kL
	dhqzgKLElO6H7BC2lsSXH/vY0L3FK+Ag0fmyg3kCo/IsJKlZSNpnIWlHVrOAkWUVo2hqQXJB
	cVJ6kalecWJucWleul5yfu4mRkhqmLiD8f4B60OMycA4mcgsJZqcD0wteSXxhsZmRhamJqbG
	RuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpglFo0d3fDp2n96d/jyo0U
	tNQOV7dLqOvef+B0vZ9f8pbo4u0BKblpt1NL56TOPZ23rv9O3QKGt4VmulLfQuykiwL19M7O
	3K29VcX0VaVDauyxVaafDT58W7tA5NE/vRi+Zxdl+vWUhf4FeismJGwWLjGo1N38pPrYDKct
	jEyM6qLFBSbFa+qVWIozEg21mIuKEwFF9I47IwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e/2TN2ayf2BBud2aFlc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jC1bXzEVrBKs+HT4JlMD4xuBLkZODiEBFYmW/98ZQWwJAROJI7MmMkPYYhIX7q1n62LkAqqZ
	zyjR0b6CBSTBIqAqcWLbP1YQm01AW+LtlwdgtrCAocSTx7fAmkUE/CUmPJzOAtLMLPCPUWLH
	9L/sENvkJSafvgxm8woISpyc+YQFYpuSRNOnb0wQcWWJKW82M0HEJSRmTb/ACmHzSsxofwpV
	Lycx7esaqEulJc7P2sAIc/Xi74+h4vwSx27vAJrDAdb75H4wzJjdm7+wQdgCElPPHIRqVZeY
	u3Ay1CpNib7ly+HG7DoFY/NK3N8yF+w0ZgFFiSndD9khbC2JLz/2saF7i1fAQaLzZQfzBEa5
	WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9AoTveLE3OLSvHS95PzcTYzgJPVsyQ7GhgvWhxgF
	OBiVeHgT9vcFCrEmlhVX5h5ilOBgVhLhvR/XHyjEm5JYWZValB9fVJqTWnyIMRkYgxOZpUST
	84EJNK8k3tDYwNjQ0NLcwNTQyII0YSVx3met1oFCAumJJanZqakFqUUwW5g4OKUaGCfe2Dir
	1Kyktdhlh1Gc2VVFKRb/g1Pr+UVnTVp9OHDplKV5RUz5SwTVb7NXLZJ8JR77LTCn7klSxM/A
	qV8zeyw6lz861dcsHZMV66136CE779eU5pREoR+2OdMmyn7eYxC5/5fgFSWm51VyTz8rlr9t
	nszwQrEiXn/lhP2WbeK2Oay/g2XYlFiKMxINtZiLihMBqyHYcZYDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4CD5bbk029488



>> Since at this point it's safer to rollback the change and we can
>> investigate more deeply how to fix it correctly for the next
>> development cycle, this is the patch which I'm testing.

>>                     - Ted

> Hello, I've tested with your patch. But the same problem was reproduced.
> Currently, I'm trying to git bisect. If i done git bisect, i will let you know.

Hi, I've done git bisect. and panic at jbd2_journal_put_journal_head() is caused by 
ae4647fb7654676fc44a97e86eb35f9f06b99f66: "jbd2: reduce journal_head size."
I write just code patch which revert ae4647fb7654676fc44a97e86eb35f9f06b99f66 because
I don't know the root cause. 


Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 include/linux/journal-head.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
index 13a3da2..c18b46f 100644
--- a/include/linux/journal-head.h
+++ b/include/linux/journal-head.h
@@ -31,14 +31,21 @@ struct journal_head {
 	/*
 	 * Journalling list for this buffer [jbd_lock_bh_state()]
 	 */
-	unsigned b_jlist:4;
+	unsigned b_jlist;
 
 	/*
 	 * This flag signals the buffer has been modified by
 	 * the currently running transaction
 	 * [jbd_lock_bh_state()]
 	 */
-	unsigned b_modified:1;
+	unsigned b_modified;
+
+	/*
+	 * This feild tracks the last transaction id in which this buffer
+	 * has been cowed
+	 * [jbd_lock_bh_state()]
+	 */
+	tid_t b_cow_tid;
 
 	/*
 	 * Copy of the buffer data frozen for writing to the log.
-- 
1.7.0.4


Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
