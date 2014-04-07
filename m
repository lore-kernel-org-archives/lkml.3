Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaDGDm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 23:42:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21388 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaDGDmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 23:42:25 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f156d00000276c-4e-53421ea0ca7e
Content-transfer-encoding: 8BIT
Message-id: <1396842028.24638.4.camel@kjgkr>
Subject: Re: f2fs: kernel BUG at fs/f2fs/segment.h:543
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-f2fs-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Date: Mon, 07 Apr 2014 12:40:28 +0900
In-reply-to: <5342058E.4090500@oracle.com>
References: <53401D4A.1020203@oracle.com> <1396833642.12401.12.camel@kjgkr>
 <5342058E.4090500@oracle.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ90Fck7BBm1t0hZbrjcxWVxa5G5x
	edccNovFR24zO7B47F7wmcnj49NbLB7v911l8/i8SS6AJYrLJiU1J7MstUjfLoErY/27+UwF
	a3kqTqx/xtzA+Imzi5GTQ0LAROLaou+sELaYxIV769m6GLk4hASWMUpsb/vJCFN04+o2RojE
	IkaJjS/eMYMkeAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPWvGCUaj8xlh6jXkbg0
	/QhYvbCAmcSqOewgJpuAtsTm/QYgFUICihJv998Fu0dEQEPi1KyDbBAjCyQOtt9hArFZBFQl
	Jm+9wAJicwpoSczf85sZojdb4uGD92A1/AKiEocXbmeGOF9JYnd7JzvIORICp9glmtbcZ4MY
	JCDxbfIhsHMkBGQlNh2AqpeUOLjiBssERolZSJ6chfDkLCRPLmBkXsUomlqQXFCclF5krFec
	mFtcmpeul5yfu4kREnf9OxjvHrA+xJgMtHEis5Rocj4wbvNK4g2NzYwsTE1MjY3MLc1IE1YS
	573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OcsBd9MxrWvg3IEF2wdsnHByYfnJ6l
	P2ebKOgbE3dqAcOCCT+Wv/3Ovkx/VcjlcuOPL85uF3KcoS+Y2aOeH1Qyj0XvhynrHRaXk2Yq
	GUvEX/WHexscu/n3zxa5Rz0XX89K+73ZfZm5hWZb+INyrTXx8dwvNm/ZrrUh82FUG0Naov03
	WV8OtgolluKMREMt5qLiRACGbbkn0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd0Fck7BBvd7xS22XG9isri0yN3i
	8q45bBaLj9xmdmDx2L3gM5PHx6e3WDze77vK5vF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8b6d/OZCtbyVJxY/4y5gfETZxcjJ4eEgInEjavbGCFsMYkL99az
	dTFycQgJLGKU2PjiHTNIgldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvEDFH/ilGi8chc
	doh6HYlL04+A1QsLmEmsmsMOYrIJaEts3m8AUiEkoCjxdv9dVhBbREBD4tSsg2wQIwskDrbf
	YQKxWQRUJSZvvcACYnMKaEnM3/ObGaI3W+Lhg/dgNfwCohKHF25nhjhfSWJ3eyf7BEahWUiO
	noVw9CwkRy9gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzVz6R3MK5qsDjEKMDBqMTD
	G3jAMViINbGsuDL3EKMEB7OSCO9udqdgId6UxMqq1KL8+KLSnNTiQ4zJQIdPZJYSTc4HJpy8
	knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBUtNzCdss/6A8X
	r3PD7AU7uG24TMNVIp4c5DpybZ2a2HvGg+UXZnNHRyvu/bbor+guhZIPtS48zP6COUo/pjU7
	ySfKflI1d+Z9e/U//wPB7cyZwoL/7a20TwU+6zyrleeQ9rD+rOPUXG7GGzvD60w38hcLyx1Y
	HDBFN/ldOWN+lO8U3ceBx5RYijMSDbWYi4oTATkasfAuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-06 (일), 21:55 -0400, Sasha Levin:
> On 04/06/2014 09:20 PM, Jaegeuk Kim wrote:
> > Hi,
> > 
> > Thank you for the report.
> > 
> > If possible, could you share fsck.f2fs or dump.f2fs on the corrupted
> > partition?
> > 
> > Otherwise, how about this?
> > # fdisk /dev/sdx
> >> > p
> 
> Hey Jaegeuk,
> 
> Unfortunately it was a temporary filesystem inside the fuzzer that has
> gone away as soon as the kernel died, so I don't have access to it.

Got it.
Then, just for sure, if it is reproducible, could you test f2fs with the
following patch?
Thanks,

>From 84f80a126458eeeaa3c4ebcecfb6908f7d22b214 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Mon, 7 Apr 2014 12:37:39 +0900
Subject: [PATCH] test

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7091204..d9cf06e 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -540,6 +540,11 @@ static inline void verify_block_addr(struct
f2fs_sb_info *sbi, block_t blk_addr)
 	block_t total_blks = sm_info->segment_count <<
sbi->log_blocks_per_seg;
 	block_t start_addr = sm_info->seg0_blkaddr;
 	block_t end_addr = start_addr + total_blks - 1;
+	if (blk_addr < start_addr) {
+		f2fs_msg(sbi->sb, KERN_ERR,
+			"blk_addr: %ld, start: %ld, end: %ld",
+			blk_addr, start_addr, end_addr);
+	}
 	BUG_ON(blk_addr < start_addr);
 	BUG_ON(blk_addr > end_addr);
 }
-- 
1.8.4.474.g128a96c


-- 
Jaegeuk Kim
Samsung

