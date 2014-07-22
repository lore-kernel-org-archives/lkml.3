Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaGVDPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 23:15:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63506 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaGVDPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 23:15:34 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-44-53cdd7538549
Date: Tue, 22 Jul 2014 03:15:31 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Re: Re: Re: [PATCH] lib : lz4 using put_unaligned_le16 instead of
 put_unaligned
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "chanho.min@lge.com" <chanho.min@lge.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140722030307892@eunb.song
Msgkey: 20140722030307892@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140722030307892@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <19235674.212171405998930057.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zbd3g62eDDU60cFtc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMeLxBpOARe8WEvx/YGhiPsHcxcnIICahItPz/zghiSwiYSCxu7mKH
	sMUkLtxbz9bFyAVUs4xR4vuKV+wwRQf3vGSFSMxhlDj97RtYN4uAqsS2lrfMIDabgLbEjwNX
	wWxhgQiJQx++soLYIgJaEr3tx4HqOTiYBfIkJqyUgjhCXmLy6ctg83kFBCVOznzCArFLSWLP
	y02MEHFlia7jP6HiEhKzpl9ghbB5JWa0P4WKy0lM+7qGGcKWljg/awMjzDOLvz+GivNLHLu9
	gwnkBJDeJ/eDYcbs3vyFDcIWkJh65iBUq7pEx/lzUHE+iTUL30KtEpQ4fa2bGab3/pa5TCA2
	s4CixJTuh+wQtpbElx/72NC9xSvgJLF2712mCYzKs5CkZiFpn4WkHVnNAkaWVYyiqQXJBcVJ
	6UVGyHG9iRGSBPt2MN48YH2IcT8jMEomMkuJJucD02heSbyhsZmRhamJqbGRuaUZhcImphYW
	JkZUEVYS5130MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PMkt8nIhKrLWZNNmoRXrDC
	4959k1tWtb+FEl2XnsmfbP600+2IXutKptd3VF3m/OWfkXTxUuvso7EWZyV/5r68Yq7leeDq
	qiLOcpW93Tc27dl765vd1WkrzD+ZlCvOYmLatUs7zCZvi9E699l2t3wM1y2M+2S2wsh+B2NT
	VH1q35Vc8RVrvFcosRRnJBpqMRcVJwIAe4k20vUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e92n27w9bPBBi9mc1hc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jMcbRAoesVdM+PuBrYHxCHsXIyeHkICKRMv/74wgtoSAicTBPS9ZIWwxiQv31rN1MXIB1cxh
	lDj97RtYEYuAqsS2lrfMIDabgLbEjwNXwWxhgQiJQx++gjWLCGhJ9LYfB6rn4GAWyJOYsFIK
	Ype8xOTTl8H28goISpyc+YQFYpeSxJ6Xmxgh4soSXcd/QsUlJGZNvwB1D6/EjPanUHE5iWlf
	1zBD2NIS52dtYIS5efH3x1Bxfoljt3cwgZwA0vvkfjDMmN2bv7BB2AISU88chGpVl+g4fw4q
	ziexZuFbqFWCEqevdTPD9N7fMpcJxGYWUJSY0v2QHcLWkvjyYx8burd4BZwk1u69yzSBUW4W
	ktQsJO2zkLQjq1nAyLKKUTS1ILmgOCm9wlivODG3uDQvXS85P3cTIzg9PVu8g/H/eetDjAIc
	jEo8vBbyZ4OFWBPLiitzDzFKcDArifC27wEK8aYkVlalFuXHF5XmpBYfYkwGxt9EZinR5Hxg
	6swriTc0NjA2NLQ0NzA1NLIgTVhJnDf+VlKQkEB6YklqdmpqQWoRzBYmDk6pBkY29owEbS6W
	IzdWrZz3wdiVs0ngVKDSQ7WDa/8f9szsN53Mo2tZ9Sz3q4OPU2K0xKSplc1zKj+/1baWaGTX
	M+RTuaFlGXI5kaPg+ZUqVr/XK53/PQzaIKVVXbl0jZZ6zJE3ns1pqwuvm0qabIxI3D+Xac0F
	2wmXrZtc56jsmdFlJty7bVnJCiWW4oxEQy3mouJEAIR1nG2TAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6M3FmxR002989


> So it's never worked?
Yes, it's always failed to mount. 
> Did you test on a little endian machine after making this change?
Unfortunately, i don't have little endian machine. So i couldn't test that.

Additionaly, when lz4 compress calls lz4_compressctx() function and uses LZ4_WRITE_LITTLEENDIAN_16() macro.
And When lz4 decompress  calls lz4_uncompress_unknownoutputsize function and 
uses LZ4_READ_LITTLEENDIAN_16 macro.
There is endian mismatch in big endian machine as i metioned before. when compress lz4 write big endian bytes order
and when decompress lz4 reads little endian bytes order. 
So i means we should make there is no endian mismatch between compress and decompress operation.

Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
