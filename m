Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaGVCD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:03:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13679 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaGVCDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:03:25 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-b2-53cdc66b2820
Date: Tue, 22 Jul 2014 02:03:23 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] lib : lz4 using put_unaligned_le16 instead of put_unaligned
To: gregkh@linuxfoundation.org
Cc: chanho.min@lge.com, linux-kernel@vger.kernel.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140722015751658@eunb.song
Msgkey: 20140722015751658@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140722015751658@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6506286.203381405994602250.JavaMail.weblogic@epml18>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zXd3sY2eDDSZMVrC4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqY0Xt2H1vBBs6Kmd1/WRoYezi7GDk5hARUJFr+f2cEsSUETCQm/5/N
	BmGLSVy4t54NomYZo8TaCWYwNe8W/gCq5wKKz2GUWHpzLStIgkVAVWLalJvsIDabgLbEjwNX
	mUFsYQEfic3TlzKB2CICyhJrVq0FW8Ys4CCx685qVogF8hKTT18G6+UVEJQ4OfMJC8QyJYl5
	196yQsSVJdbt3wUVl5CYNf0CK4TNKzGj/SlUXE5i2tc1zBC2tMT5WRsYYZ5Z/P0xVJxf4tjt
	HUD3cID1PrkfDDNm9+YvUL8LSEw9cxCqVV1i2a1DUDafxJqFb6FWCUqcvtbNDNN7f8tcJoi3
	FCWmdD9kh7C1JL782MeG6i0OINtRYs9SnwmMyrOQZGYh6Z6FpBtZzQJGllWMoqkFyQXFSelF
	RshxvYkRkgT7djDePGB9iHE/IzBKJjJLiSbnA9NoXkm8obGZkYWpiamxkbmlGYXCJqYWFiZG
	VBFWEudd9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjWajNGZYgA+dL/+r++ZQ/PHOK
	ueBYbfKrNsu1Oy7mSMwOuXKhKjSBMWTSjZwCtYPpW0MfCZoa8rDMf7e+bG8pw9+tLc/u9sf+
	Kr6/SfxZ7gIf43+//kSEv72xt/S/+X9n5eX+kZZ6lj3Xbp55crokwOpu4focjg35zPuS7AWv
	sfi4BP2ZfzBeiaU4I9FQi7moOBEAmaMh4fUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e92v272sbPBBtd+yFhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jN6z+9gKNnBWzOz+y9LA2MPZxcjJISSgItHy/zsjiC0hYCLxbuEPKFtM4sK99WxdjFxANXMY
	JZbeXMsKkmARUJWYNuUmO4jNJqAt8ePAVWYQW1jAR2Lz9KVMILaIgLLEmlVrwQYxCzhI7Lqz
	mhVimbzE5NOXwXp5BQQlTs58wgKxTEli3rW3rBBxZYl1+3dBxSUkZk2/wAph80rMaH8KFZeT
	mPZ1DTOELS1xftYGuKMXf38MFeeXOHZ7B9A9HGC9T+4Hw4zZvfkLG4QtIDH1zEGoVnWJZbcO
	Qdl8EmsWvoVaJShx+lo3M0zv/S1zmSDeUpSY0v2QHcLWkvjyYx8bqrc4gGxHiT1LfSYwys1C
	kpmFpHsWkm5kNQsYWVYxiqYWJBcUJ6VXGOoVJ+YWl+al6yXn525iBCeoZwt3MH45b32IUYCD
	UYmH10L+bLAQa2JZcWXuIUYJDmYlEd72PUAh3pTEyqrUovz4otKc1OJDjMnA+JvILCWanA9M
	nnkl8YbGBsaGhpbmBqaGRhakCSuJ8969mRQkJJCeWJKanZpakFoEs4WJg1OqgTH5oN62WzaM
	gbNcfURTLtvEtsbIPl9qLV8zZ2n6d7V7ArPFi9mP8kUYHtb7uom39ub7W35FNSVz/qzQ3tfz
	8ZkfY9dLM4OjRetr3pvOe1z9yTty75m5OouiV2y13OVreXq+hvIEbWvZGdq32LY9mGscIfPX
	kX3rvdP/TT7UKyYGZc+qC331QFWJpTgj0VCLuag4EQDHYVt+lAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6M23XVV002414


In case of mips bigendian machine, put_unaligned writes bigendian bytes order. 
This is defined in arch/mips/include/asm/unaligned.h. So it's right use put_unaligned_le16 function instead of put_unaligned.
This patch also fixes problem fail to mount zram ext4 partition with "zram: Decompression failed! err=-1, page=0" in mips bigendian machine.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 lib/lz4/lz4defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/lz4/lz4defs.h b/lib/lz4/lz4defs.h
index abcecdc..dc7ef14 100644
--- a/lib/lz4/lz4defs.h
+++ b/lib/lz4/lz4defs.h
@@ -53,7 +53,7 @@ typedef struct _U64_S { u64 v; } U64_S;
 
 #define LZ4_WRITE_LITTLEENDIAN_16(p, v)	\
 	do {	\
-		put_unaligned(v, (u16 *)(p)); \
+		put_unaligned_le16(v, (u16 *)(p)); \
 		p += 2; \
 	} while (0)
 #endif
-- 
1.7.0.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
