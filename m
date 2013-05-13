Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3EMJx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:53:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37830 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3EMJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:53:55 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-b2-5190b8170871
Date: Mon, 13 May 2013 09:53:27 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
To: Zheng Liu <gnehzuil.liu@gmail.com>, Tony Luck <tony.luck@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130513095010510@eunb.song
Msgkey: 20130513095010510@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130513095010510@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <12945098.35291368438804981.JavaMail.weblogic@epv6ml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zPV3xHRMCDR5O17G4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ7+/9YS24xVOxZNdypgbGNTxdjJwcQgIqEi3/vzOC2BICJhI3
	L56CssUkLtxbz9bFyAVUs4xR4sPVdlaYonXPV7NDJOYzSvzad58JJMEioCrx8dlFdhCbTUBb
	4u2XB2ANwgJeEq1rPrGB2CICvhKLz75jAmlmFjjLKLHl4R4WiDPkJSafvgzWzCsgKHFy5hMW
	iG1KEle/PmSBiCtLbDnfxQ4Rl5CYNf0C1EW8EjPan0LVy0lM+7qGGcKWljg/awPcO4u/P4aK
	80scu70D6AgOsN4n94Nhxuze/IUNwhaQmHrmIFSrusSZy++g1vJJrFn4lgVmzK5Ty5lheu9v
	mQsOB2YBRYkp3Q/ZIWwtiS8/9rGhe4tXwFli68d/rBMYlWchSc1C0j4LSTuymgWMLKsYRVML
	kguKk9KLDPWKE3OLS/PS9ZLzczcxQlJD7w7G2wesDzEmA+NkIrOUaHI+MLXklcQbGpsZWZia
	mBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRvfq4yi6+aSUnVreK
	nis9zK62qtHrepbCZxfJI6/aqm7UPm6u/6+x787sRge+vF2BlVx+y1x08h7MqZDyLtA+dazr
	usbnXzc+TQpIKxHffLX97sIPK1/Kpbc79m5lPf7n1qLX2qU78tYcdD7PJXNe2fPVWz+mogpR
	7XstL4oWGs7iFzj3/CyvEktxRqKhFnNRcSIAHer+OSMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e/2DF3xHRMCDSb907C4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	Ge/v/WEtuMVTsWTXcqYGxjU8XYycHEICKhIt/78zgtgSAiYS656vZoewxSQu3FvP1sXIBVQz
	n1Hi1777TCAJFgFViY/PLoIVsQloS7z98oAVxBYW8JJoXfOJDcQWEfCVWHz2HRNIM7PAWUaJ
	LQ/3sEBsk5eYfPoyWDOvgKDEyZlPWCC2KUlc/fqQBSKuLLHlfBfUFRISs6ZfYIWweSVmtD+F
	qpeTmPZ1DTOELS1xftYGRpirF39/DBXnlzh2ewfQERxgvU/uB8OM2b35CxuELSAx9cxBqFZ1
	iTOX30Gt5ZNYs/AtC8yYXaeWM8P03t8yFxwOzAKKElO6H7JD2FoSX37sY0P3Fq+As8TWj/9Y
	JzDKzUKSmoWkfRaSdmQ1CxhZVjGKphYkFxQnpVcY6xUn5haX5qXrJefnbmIEJ6lni3cw/j9v
	fYhRgINRiYfXQ3FCoBBrYllxZe4hRgkOZiURXsvNQCHelMTKqtSi/Pii0pzU4kOMycAYnMgs
	JZqcD0ygeSXxhsYGxoaGluYGpoZGFqQJK4nzPmu1DhQSSE8sSc1OTS1ILYLZwsTBKdXAaJ58
	M6b4UoGC3hbWtWcOd7qY96e3rHw9q46v9cFv7uaHyXpfflbsMLE+/VjmVIr+sfDq9eb10SGv
	592S3Cxd0qQayq/o3M5o3b98T1Xb4aaz5S+MOQ95mHe6xTrH1V3LLzFR+7SN1zHct36y4umj
	M+yyPv9nfn4q+7NZFtdvQ+6I+kjuj8ZKLMUZiYZazEXFiQDyDg0BlgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4D9s3b4032671



> Hi all,

> First of all I couldn't reproduce this regression in my sand box.  So
> the following speculation is only my guess.  I suspect that the commit
> (ae4647fb) isn't root cause.  It just uncover a potential bug that has
> been there for a long time.  I look at the code, and found two
> suspicious stuff in jbd2.  The first one is in do_get_write_access().
> In this function we forgot to lock bh state when we check b_jlist ==
> BJ_Shadow.  I generate a patch to fix it, and I really think it is the
> root cause.  Further, in __journal_remove_journal_head() we check
> b_jlist == BJ_None.  But, when this function is called, bh state won't
> be locked sometimes.  So I suspect this is why we hit a BUG in
> jbd2_journal_put_journal_head().  But I don't have a good solution to
> fix this until now because I don't know whether we need to lock bh state
> here, or maybe we should remove this assertation.
>
> So, generally, Tony, Eunbong, could you please try the following patch?
>
> Thanks in advance,
>                                                 - Zheng


Hi, I tested your patch. Unfortunately, the same problem was reproduced.
Thanks.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
