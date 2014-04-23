Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaDWX4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:56:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9235 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaDWX4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:56:38 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7fcd6d0000026e0-cf-53585334b9a5
Content-transfer-encoding: 8BIT
Message-id: <1398297270.4283.19.camel@kjgkr>
Subject: Re: f2fs causes system stall
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 24 Apr 2014 08:54:30 +0900
In-reply-to: <2601952.jk1l5iHOJT@ax5200p>
References: <2601952.jk1l5iHOJT@ax5200p>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t8zQ12T4Ihgg9fvpCwu75rDZtF5fiGj
	A5PHh49xHp83yQUwRXHZpKTmZJalFunbJXBl3H+4ia3gK1vFiWd3mRsY17B2MXJySAiYSHTs
	P8QEYYtJXLi3nq2LkYtDSGAZo8T/zuNACQ6wojvH9EFqhASmM0p8Pi0MYvMKCEr8mHyPBaSE
	WUBe4silbJAws4C6xKR5i5ghxrxilDg4/w8jRL2OxLKWZ2B7hQVUJXa8bAQbzyagLbF5vwHE
	eEWJt/vvsoKERQSUJb4uUoQYqS+xZfUGRpAwC1Dns9YgkDCngKZE/7ut7BCdGhJvb99lAbH5
	BUQlDi/czgzxlJLE7vZOdgh7FbvE4Y5oEJtFQEDi2+RDLBD/yUpsOgBVLilxcMUNlgmMErOQ
	vDgL4cVZSF5cwMi8ilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkjibsYLx3wPoQYzLQxonM
	UqLJ+cA4zCuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGRu4Z5uqv7j2aIVQjnnVr9/UV8b35b7b7snW2LXG90mktU3fSrMt0RofK/FMCpzU5/N9v
	2FO8YjGX6muDKVwTOV9dvXp/V+Eq/t51exbyT9y7r7XfQDSoMf1mXcXKxIMrPU5UrnB6+srr
	yJeZvVc45/MUHdQ0rjS9vqDk7u2nbIWK8yRlpPgD0pRYijMSDbWYi4oTAUv8vCe5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xoK5JcESwwfJV4haXd81hs+g8v5DR
	gcnjw8c4j8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
	lVx8AnTdMnOAxisplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM+4/3MRW
	8JWt4sSzu8wNjGtYuxg5OCQETCTuHNPvYuQEMsUkLtxbzwZiCwlMZ5T4fFoYxOYVEJT4Mfke
	C0g5s4C8xJFL2SBhZgF1iUnzFjF3MXIBlb9ilDg4/w8jRL2OxLKWZ6wgtrCAqsSOl41MIL1s
	AtoSm/cbQIxXlHi7/y7YBSICyhJfFylCjNSX2LJ6AyNImAWo81lrEEiYU0BTov/dVnaITg2J
	t7fvsoDY/AKiEocXbmeGOF5JYnd7J/sERqFZSG6ehXDzLCQ3L2BkXsUomlqQXFCclJ5rqFec
	mFtcmpeul5yfu4kRHKfPpHYwrmywOMQowMGoxMN74EJ4sBBrYllxZe4hRgkOZiUR3jyPiGAh
	3pTEyqrUovz4otKc1OJDjMlAd09klhJNzgemkLySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYFyxOsNvS7pwy4+/BrsenRPSnrojraVt06OfWnsFNnJ7vzI+
	/J9xEb8/62GZjqP9r7ZV7ZgYut464t0GldKahnLbef8n+b1/wRU4+7SI+jzW85KaOo7nQmo+
	HI5earHA3Xcuh3oY9wufJrYC9x86+QtETT7cvuiZ12BruuSO8emSPgGXtorebUosxRmJhlrM
	RcWJAKRZ0N4XAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for the report.
When I veiwed the patch at a glance, it seems that reverting is not a
good way.

Instead, could you share the f2fs commit point that you're using?
Then, since I have a suspect for this issue, I'd like to write a patch
to test.

Thanks,

2014-04-24 (목), 00:00 +0200, Marc Dietrich:
> Hi,
> 
> it took me a while to bisect a problem which causes my ARM (tegra2) netbook to 
> frequently stall for 5-10 seconds when I enable EXA acceleration (opentegra 
> experimental ddx). I can only guess that the offending commit 8618b88 "f2fs: 
> fix not to write data pages on the page reclaiming path" somehow causes high 
> kernel latencies which may interrupt/disturb the command stream to the gpu in 
> this particular case. Reverting this commit fixes the problem. Any hints?
> 
> Regards,
> 
> Marc
> 

-- 
Jaegeuk Kim
Samsung

