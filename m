Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaD3CVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:21:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14876 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaD3CVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:21:03 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-ed-53605e0cca4d
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Catalin Marinas'" <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
References: <000301cf6367$ca12e150$5e38a3f0$@samsung.com>
 <20140429144506.GK17007@arm.com>
In-reply-to: <20140429144506.GK17007@arm.com>
Subject: Re: [PATCH v4 3/7] arm64: Introduce a kernel configuration option for
 VA_BITS
Date: Wed, 30 Apr 2014 11:21:00 +0900
Message-id: <007901cf641a$d3fbb710$7bf32530$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQFwZU1QXBtbYiurPo5wYSZk02SVcQHdJLEvm9iBfmA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zvi5PXEKwwd/9FhZ/Jx1jt3i/rIfR
	4sXrf4wWR/8tZLToXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCz+3vnHZrFi3jI2iw8zVjI6
	8HismbeG0eP3r0mMHneu7WHzOL9pDbPH5iX1Hn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJWx
	/Nkh1oIjrBXfJk5hbmBcxtLFyMkhIWAiMWP6JDYIW0ziwr31QDYXh5DAMkaJ37N/MXcxcoAV
	Hb0pCxFfxCjRu24LM4Tzh1Fi2c9pYN1sApoSj+72sIPYIgL6Eouv3GAFKWIW6GCWWPp0GSNI
	QkggRqJl92WwBk4BXYm1S6aANQgLREj0nZsEdhKLgKrE9XmfwOp5BSwl+hasgLIFJX5MvgdW
	wyygJbF+53EmCFteYvOat8wQLyhI7Dj7mhEiLiKx78U7RoiDrCQ23nsOdrWEwEIOicmdO5gg
	lglIfJt8iAXiTVmJTQeg5khKHFxxg2UCo8QsJKtnIVk9C8nqWUjWLWBkWcUomlqQXFCclF5k
	rFecmFtcmpeul5yfu4kRkgT6dzDePWB9iDEZaP1EZinR5HxgEskriTc0NjOyMDUxNTYytzQj
	TVhJnPf+w6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw8P/0vTk3kZ20+IpXOqLnH2Lfq
	QWabRKh5WfqJBTxe/22l1tTeWRe2vvvQOScvf3f5CkHe0hR1HqYXzPdY9ReuW9bIu3Fpftit
	T58XPsg4/ms6N1PsnP8/zF81dZu9TQ44/3bGl3SReXNCWXcFmc3Wemrqdb9qN6vpiZhM9bbW
	D9K+TDo3o5VYijMSDbWYi4oTAQcfwrUYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAV2euIRggyczjS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxvJnh1gLjrBWfJs4hbmBcRlLFyMHh4SAicTRm7JdjJxA
	ppjEhXvr2boYuTiEBBYxSvSu28IM4fxhlFj2cxobSBWbgKbEo7s97CC2iIC+xOIrN1hBipgF
	Opgllj5dxgiSEBKIkWjZfRmsgVNAV2LtkilgDcICERJ95yaxgNgsAqoS1+d9AqvnFbCU6Fuw
	AsoWlPgx+R5YDbOAlsT6nceZIGx5ic1r3jJDnKogsePsa0aIuIjEvhfvGCEOspLYeO858wRG
	oVlIRs1CMmoWklGzkLQvYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcYp5J7WBc2WBx
	iFGAg1GJh1dga3ywEGtiWXFl7iFGCQ5mJRFe5oCEYCHelMTKqtSi/Pii0pzU4kOMyUCfTmSW
	Ek3OB6a/vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg9Gnu
	6IuR0Fpt87TryAs/1j88qlNuv80ICvy56aP4hNcna4+tv/CAbWODmrLl+7KT1j1/c3c3Mi+/
	eUqmVF8/3uL+RwaLn7/+Fx8sZj/+WtghzmCpv/Skt8nzvDL/tUhcl8xTUXlwbznz2xY3772/
	D1dFqb1cFLqedWPmmr+nOneL2uU7lz26pMRSnJFoqMVcVJwIANhMxX51AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 11:45 PM, Catalin Marinas wrote:
> On Tue, Apr 29, 2014 at 05:59:23AM +0100, Jungseok Lee wrote:
> > +config ARM64_VA_BITS
> > +	int "Virtual address space size"
> > +	range 39 39 if ARM64_4K_PAGES && ARM64_3_LEVELS
> > +	range 42 42 if ARM64_64K_PAGES && ARM64_2_LEVELS
> > +	help
> > +	  This feature is determined by a combination of page size and
> > +	  level of translation tables.
> 
> OK, so you are doing the VA bits selection already. But see my other
> email about setting only exposing this and hiding the number of levels
> (though number of levels can be mentioned in the help).

Okay. I will hide the number of levels.

Best Regards
Jungseok Lee

