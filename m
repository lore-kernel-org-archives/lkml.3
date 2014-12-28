Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaL1WyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 17:54:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31011 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaL1WyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 17:54:07 -0500
X-AuditID: cbfee68e-f79b46d000002b74-01-54a08a0c88a7
Date: Mon, 29 Dec 2014 07:52:53 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 26 (f2fs)
Message-id: <20141228225253.GG3335@lcm>
References: <20141226193009.60d3f62e@canb.auug.org.au>
 <549DB43B.7050902@infradead.org> <20141226205822.GA21870@jaegeuk-mac02>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20141226205822.GA21870@jaegeuk-mac02>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWyRsSkXZena0GIwbOL0hZP1s9itri8aw6b
	xcGFbYwWb+9MZ7HYuvcquwOrR+ONG2wem1doeWxa1cnm8XmTXABLFJdNSmpOZllqkb5dAlfG
	rc+3WAvusFW8n9XO1MA4nbWLkZNDQsBE4t2POWwQtpjEhXvrgWwuDiGBpYwSnUdOAjkcYEXT
	fkiB1AgJTGeUmPCVGaLmJ6PE6YlPmEESLAKqEv33ZrGA2GwCWhLtp9eC2SICKhKHFl1mB2lg
	FuhnlFj/+AgjSEJYQF9i/7KHYFfwCqhLNP5/yQ4xtYFRovHzEhaIhKDEj8n3wGxmoKnrdx5n
	grClJR79ncEOYnMKGEt8+bsNbJAo0LYpJ7eBvSAhsItd4u3Ho1DnCUh8m3yIBeIdWYlNB5gh
	XpaUOLjiBssERrFZSNbNQrJuFpJ1CxiZVzGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIERtbp
	f8/6djDePGB9iFGAg1GJh3fCsfkhQqyJZcWVuYcYTYGumMgsJZqcD4zfvJJ4Q2MzIwtTE1Nj
	I3NLMyVx3gSpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGL3PLMlJea795qtuxYrj4ls7
	lio8KFSIsbCov9Vz/WXxXmPOB60Jr77tzyk+Ovfzh7VeP/52vNN4OGVRwO7lPrr7f++4/F5F
	deVa6/5F3Jyre1rEQu5V+sk9T5M2KNkQfzzaMO2379krz0XK7/izcbAeuMbee2jmpJ8MM0Nu
	1M104lVbqRO+/4ASS3FGoqEWc1FxIgCzdio3pwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQV2ergUhBtOOi1s8WT+L2eLyrjls
	FgcXtjFavL0zncVi696r7A6sHo03brB5bF6h5bFpVSebx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGbc+32ItuMNW8X5WO1MD43TWLkYODgkBE4lpP6S6GDmB
	TDGJC/fWs4HYQgLTGSUmfGXuYuQCsn8ySpye+IQZJMEioCrRf28WC4jNJqAl0X56LZgtIqAi
	cWjRZXaQBmaBfkaJ9Y+PMIIkhAX0JfYve8gKYvMKqEs0/n/JDjG1gVGi8fMSFoiEoMSPyffA
	bGagqet3HmeCsKUlHv2dwQ5icwoYS3z5uw1skCjQtiknt7FNYBSYhaR9FpL2WUjaFzAyr2IU
	TS1ILihOSs810itOzC0uzUvXS87P3cQIjttn0jsYVzVYHGIU4GBU4uGdcGx+iBBrYllxZe4h
	RgkOZiURXqOyBSFCvCmJlVWpRfnxRaU5qcWHGE2B4TGRWUo0OR+YUvJK4g2NTcyMLI3MLIxM
	zM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhg7uK/9iPpbktzRx+k+ZVrVnhcKSa0N2V/2
	rU4LlPc0ftnD/LB/4qajE5dPNlv0Z1/xr1oD310sTy3Yn+yqtXlUnBti79zMk/+3ttC2XitP
	pc/lOWO/TeAa7h7xR/JXvjsfSlzNF132xYPrcZdvpNnZ9VLCRgxfGDer3D2x/l3Y1I73zAaz
	PyixFGckGmoxFxUnAgBXJZiy8QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 12:59:05PM -0800, Jaegeuk Kim wrote:
> I fixed the merged patch directly.
> 
> Changman,
> The patch was initially made by you, so let me know, if you have objection.
> 
> Thanks,

Sorry for my mistake.
Thanks, Stephen and Jaegeuk.

> 
> On Fri, Dec 26, 2014 at 11:17:15AM -0800, Randy Dunlap wrote:
> > On 12/26/14 00:30, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > There will only be intermittent releases of linux-next between now and
> > > Jan 5.
> > > 
> > > Changes since 20141221:
> > > 
> > 
> > on x86_64:
> > when CONFIG_F2FS_STAT_FS is not enabled:
> > 
> > ../fs/f2fs/segment.c: In function 'rewrite_data_page':
> > ../fs/f2fs/segment.c:1233:2: error: implicit declaration of function 'stat_inc_inplace_blocks' [-Werror=implicit-function-declaration]
> > 
> > 
> > 
> > -- 
> > ~Randy
