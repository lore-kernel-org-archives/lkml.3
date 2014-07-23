Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbaGWEzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:55:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51379 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaGWEzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:55:13 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-a8-53cf402f0d8c
Date: Wed, 23 Jul 2014 04:55:11 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Re: RE: [PATCH] lib : lz4 using put_unaligned_le16 instead of
 put_unaligned
To: Chanho Min <chanho.min@lge.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hyojun.im@lge.com" <hyojun.im@lge.com>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140723044751327@eunb.song
Msgkey: 20140723044751327@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140723044751327@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <30989786.490921406091310576.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zHV19h/PBBtPv61hc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMOLe0rOAfS8Wh3gtMDYwvWLoYOTmEBFQkWv5/ZwSxJQRMJKZPPMEO
	YYtJXLi3nq2LkQuoZhmjxKT3L5hhiq62HIBKzGGU+HOjlw0kwSKgKrHh0nSwIjYBbYkfB66C
	2cICIRLNU6eA2SICSRId/bPANjAL5EgsnHaJDeIKeYnJpy+DxXkFBCVOznzCArFMSeJT/2Ym
	iLiyxNvJu6Guk5CYNf0CK4TNKzGj/SlUvZzEtK9roA6Vljg/awMjzDeLvz+GivNLHLu9A2gm
	B1jvk/vBMGN2b/7CBmELSEw9cxCqVV3iZeM5qFY+iTUL30KtEpQ4fa2bGab3/pa5TBBvKUpM
	6X4I9aKWxJcf+9jQvcUr4CQx7flm9gmMyrOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXFSelFRsiR
	vYkRkgb7djDePGB9iHE/IzBOJjJLiSbnAxNpXkm8obGZkYWpiamxkbmlGYXCJqYWFiZGVBFW
	Eudd9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj/dwW2fbC6mwNJ4GeJ817jWx+zmgT
	vPr+kvjmm1+Xp4q2bRO1ffh1Le8ByTpmyZOzyp3+N27n2z2pZtXq7/u2B6cY7im569OYJuG4
	Izkg8W757HZJi34pdtmDLwU+H9KJXBrx4QCfw3cXm/fl064efnX7yQL3GWc/nt97Lme188FN
	9m5XpTe6KrEUZyQaajEXFScCACzRtj/2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e92r66+w/lggwP/NC0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xrmlZQX/WCoO9V5gamB8wdLFyMkhJKAi0fL/OyOILSFgInG15QAbhC0mceHeeiCbC6hmDqPE
	nxu9YAkWAVWJDZemM4PYbALaEj8OXAWzhQVCJJqnTgGzRQSSJDr6Z7GD2MwCORILp11ig1gm
	LzH59GWwOK+AoMTJmU9YIJYpSXzq38wEEVeWeDt5NztEXEJi1vQLrBA2r8SM9qdQ9XIS076u
	YYawpSXOz9rACHP04u+PoeL8Esdu7wCayQHW++R+MMyY3Zu/QP0oIDH1zEGoVnWJl43noFr5
	JNYsfAu1SlDi9LVuZpje+1vmMkG8pSgxpfsh1ItaEl9+7GND9xavgJPEtOeb2Scwys1CkpqF
	pH0WknZkNQsYWVYxiqYWJBcUJ6VXGOoVJ+YWl+al6yXn525iBCeoZwt3MH45b32IUYCDUYmH
	V6LqXLAQa2JZcWXuIUYJDmYlEd7X2ueDhXhTEiurUovy44tKc1KLDzEmAyNwIrOUaHI+MHnm
	lcQbGhsYGxpamhuYGhpZkCasJM5792ZSkJBAemJJanZqakFqEcwWJg5OqQZGhwyDix0NyaJ6
	j3bsVFe/vdL59+H4Jta1XefOX1jE8qX5jlPlwlOPtFbefZpdrJl1zHyi7NMVaRWeE9fvSF41
	bYqN6bRVzHsyfnw1CbD4ovBOIMHvd9Q3pwVKbfuEvtgXa9TMvtins0xXsq+x/MG/4/+fv+XY
	wWP5Z+/agi+tmyp6WRg0dU7eU2Ipzkg01GIuKk4EACfLL+yUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6N4tQYn013358



>  If your patch is applied, the data which is compressed
> by your big-endian system won't be decompressed in other little-endian system.

I can't understand this. Please, could you explain this more ?
My patch just replaces put_unaligned with put_unaligned_le16. and this just write compression data
in little endian byte-order  regardless of machine byte-order, like ext file system. 
So, i guess there is no  problem what you pointed 

Thanks. ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
