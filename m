Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaBFA3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:29:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50453 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaBFA3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:29:32 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fcd6d00000315b-b7-52f2d76a40b9
Content-transfer-encoding: 8BIT
Message-id: <1391646482.25542.72.camel@kjgkr>
Subject: Re: linux-next: bad commits in the f2fs tree
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Feb 2014 09:28:02 +0900
In-reply-to: <20140206110401.7888b06cbd651b842404b902@canb.auug.org.au>
References: <20140206110401.7888b06cbd651b842404b902@canb.auug.org.au>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zfd2s65+CDDbM57W4vGsOm8XBhW2M
	Flv3XmV3YPZovHGDzePzJrkApigum5TUnMyy1CJ9uwSujP8HP7EVfGKuOHJ/AlMDYyNzFyMn
	h4SAicTvZS+hbDGJC/fWs3UxcnEICSxjlLjz8gFLFyMHWNGX66UgNUIC0xklLs0WAbF5BQQl
	fky+B1bCLCAvceRSNkiYWUBdYtK8RcwQY14ySvxYv4oNol5XYv+3L+wg9cICphI3epxATDYB
	bYnN+w0gpitKvN1/lxUkLAIUPvBbAGKijcTs1QvYQWwWAVWJGf+ugx3MKeAu0TnpBxtEq5vE
	gx3TWUBsfgFRicMLt0M9pSSxu72THeQaCYFN7BLPvx9lgRgkIPFt8iGoB2UlNh2AqpeUOLji
	BssERolZSH6chfDjLCQ/LmBkXsUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRElW9OxhvH7A+
	xJgMtHEis5Rocj4wKvNK4g2NzYwsTE1MjY3MLc1IE1YS5016mBQkJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgXFS9BkfgT1R5Y/9GZbEGHq92XXhDce+G++lF+XGnglP/F+afNO/TFVV8s2K
	mH0OC85ZflErCU9LUF8kKlF49Mdf6aaWqUrP0gQK+3vrP8fe+r3gyZZp3NmPYoO5twUvPP7j
	DoPb5k9TllXYCRz9FNtXfJ/v037LCxrvjxg0tUXy/W26dVthwkwlluKMREMt5qLiRABZ2ed1
	wAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoG7W9U9BBjM3c1pc3jWHzeLgwjZG
	i617r7I7MHs03rjB5vF5k1wAU1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEd
	Y8b/g5/YCj4xVxy5P4GpgbGRuYuRg0NCwETiy/XSLkZOIFNM4sK99WwgtpDAdEaJS7NFQGxe
	AUGJH5PvsYCUMwvISxy5lA0SZhZQl5g0bxHQFC6g8peMEj/Wr2KDqNeV2P/tCztIvbCAqcSN
	HicQk01AW2LzfgOI6YoSb/ffZQUJiwCFD/wWgJhoIzF79QJ2EJtFQFVixr/rzCA2p4C7ROek
	H1CHuUk82DGdBcTmFxCVOLxwOzPE8UoSu9s72ScwCs1CcvMshJtnIbl5ASPzKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgmH0mtYNxZYPFIUYBDkYlHt4N6z8FCbEmlhVX5h5ilOBgVhLh
	jd4LFOJNSaysSi3Kjy8qzUktPsSYDHT4RGYp0eR8YDrJK4k3NDYxM7I0MrMwMjE3J01YSZz3
	QKt1oJBAemJJanZqakFqEcwWJg5OqQbGVimuw5+Dj16Qmbm75UP37tbNO52jJ5noGU9pzlTb
	mGv0U2UCb3mzw/+6LZ2/9HR2PDn14ZuUh10GXwmbTt3nnf+iT7+e0OcSVJTSsufjd+s6u318
	G5yrpws3R2z8vzIlPS+kvTSI7cGVBrbfxq/zDHJVreduUFjL0/p+aQTzxvuqny+dSalSYinO
	SDTUYi4qTgQAB2OowR0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

2014-02-06 (목), 11:04 +1100, Stephen Rothwell:
> Hi Jaegeuk,
> 
> Looking at the f2fs tree today, it has *copies* of several commits that
> are in Linus' tree (including b522196a6ffb "Linus 3.14-rc1" which is
> commit 38dbfb59d117 in Linus' tree).  I assume this happened when you
> tried to rewrite your tree. :-(

I fixed that.
Sorry for the mistake. :)

> 
> I can't use that tree, so will use the version of f2fs from next-20140105.

-- 
Jaegeuk Kim
Samsung

