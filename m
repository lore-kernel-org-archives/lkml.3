Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab3IDX75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:59:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42074 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab3IDX7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:59:55 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-a5-5227c979f370
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: broonie@kernel.org
References: <1378276935-14053-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1378276935-14053-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/1] regulator: s2mps11: Use devm_regulator_register
Date: Thu, 05 Sep 2013 08:59:50 +0900
Message-id: <010901cea9ca$d7f61640$87e242c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF+oV1iG04wfYLy2/OCMOA0cXl/UppWT6GQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zY92qk+pBBm0zGS2mPnzCZnF51xw2
	i5N/ehkdmD02repk87hzbQ+bx+dNcgHMUVw2Kak5mWWpRfp2CVwZe59/ZS04ylQxdXdcA2Mn
	UxcjJ4eEgInEylvHoWwxiQv31rN1MXJxCAksY5ToPLqSHaZo9oXjzBCJRYwSa06uZANJCAn8
	YZQ4sVUdxGYT0JBYufstWFxEwEvi4vzfjCA2M9DUj9vesULUu0usfP8GbCingIfEtpYDLCC2
	MJB95c4HZhCbRUBV4tyz3WAX8QpYSmxb3M4OYQtK/Jh8jwVippbE+p0QVzMLyEtsXvOWGeJQ
	BYkdZ18zQtxgJPFk/VqoGhGJfS/eMYI8ICGwjV1iy8NvbBDLBCS+TT4ENJQDKCErsekA1BxJ
	iYMrbrBMYJSYhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQiKw
	dwfj7QPWhxiTgdZPZJYSTc4HRnBeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhhnphxefK817cstQ6tpurUhQYr2qiddi+LZJxfVTj7wLJrn+24z
	jYboUoNkx9l3d787miQh0Wli8HqXe73qgucln5+n10csilo2adMdBr9cwWb9U8x39+2d5eb3
	pk1o4zTdJCabkxX/upiy/qRrPH35wsEnRoRj8pvFRZu3ldVfXySVZeHy/ooSS3FGoqEWc1Fx
	IgAtwsT61gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAd3Kk+pBBv+PWVlMffiEzeLyrjls
	Fif/9DI6MHtsWtXJ5nHn2h42j8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCesYM/Y+/8pacJSpYuruuAbGTqYuRk4OCQETidkXjjND2GISF+6tZ+ti5OIQEljEKLHm
	5Eo2kISQwB9GiRNb1UFsNgENiZW734LFRQS8JC7O/80IYjMDNX/c9o4Vot5dYuX7N+wgNqeA
	h8S2lgMsILYwkH3lzgewZSwCqhLnnu0GO4JXwFJi2+J2dghbUOLH5HssEDO1JNbvPM4EYctL
	bF7zFupQBYkdZ18zQtxgJPFk/VqoGhGJfS/eMU5gFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjB8f1MagfjygaLQ4wCHIxKPLwNxupBQqyJZcWVuYcYJTiY
	lUR4LVYChXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmHrySuINjU3MjCyNzCyMTMzNSRNW
	Euc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHxsH8Qx7Pl/KdtC0NLph94eu98tl+W1Br3Rfdd
	mUqz37TVLg18t16SkfXyb6mT4nXvP6t3PuasPRvTeoLPIP3vjLf5rP2i7BFFWWqXE+MXb039
	H8EYr/eFw7BLaE360VdFN/aZfDN80FVwYSWj2alzLi35u7lCr3brZbR76ezhf8bq7HNAT1mJ
	pTgj0VCLuag4EQCsdEoNMwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 04, 2013 3:42 PM, Sachin Kamat wrote:

> Commit e398b51a ("regulator: s2mps11: Convert to devm_regulator_register()")
> intended to do this conversion. However the actual conversion to devm_* got
> missed out. Fix this.
> 

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

