Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab3BYBv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 20:51:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21637 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab3BYBv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 20:51:26 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-de-512ac39857db
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003201ce10e9$61e11b50$25a351f0$%han@samsung.com>
 <20130222132603.9993aa86.akpm@linux-foundation.org>
In-reply-to: <20130222132603.9993aa86.akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: ams369fg06: convert ams369fg06 to dev_pm_ops
Date: Mon, 25 Feb 2013 10:51:19 +0900
Message-id: <01e501ce12fa$9b90b8c0$d2b22a40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4RQznEfNG6LjVVRuqwdTmwdvNllABtx3QQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA90Zh7UCDR4fF7W4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZVxuvMhc0s1e8fd3C3sC4jrWLkZNDQsBE4uvXQ1C2mMSFe+vZ
	uhi5OIQEljFKvP67nQmm6NiHv1CJRYwSl2e8YoFwZjNJPLp9AayKTUBN4suXw+xdjBwcIgL6
	Em0tGiBhZoFSia0P3rOA2EICxRLvWnaCbeMUcJB4tqeBDcQWFvCROHp5IlgNi4CqxK/TS8Fq
	eAVsJX61rmSDsAUlfky+xwIxU0ti/c7jTBC2vMTmNW+ZQdZKCKhLPPqrCxIWETCSWLT3HFS5
	iMS+F+8YQU6WEFjELrHswHmoXQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSYhWTzLCSbZyHZ
	PAvJigWMLKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQiKrfwfj3QPWhxiTgdZPZJYSTc4H
	RmZeSbyhsbGJmYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTA6
	1XM07xL3EMp8orYxVL3Q6WLApX9nnQ+uOXG3VpaH40GO9ya/w4+MJTm/e5ctvmC2X/ugl1n0
	8VvvtmpZtjtdi/blDLBafuy71o7fDnqcVz6Lva5PCL3lwpn0cY37x4r7F04GHBN58/q+VPP+
	E/PrjjCs/qr16X3J7Bkq6ar6Z8KXvPJP0T6mxFKckWioxVxUnAgACDCZesICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO6Mw1qBBseu8ltc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjKuNV5kLmtkr3r5uYW9g
	XMfaxcjJISFgInHsw182CFtM4sK99UA2F4eQwCJGicszXrFAOLOZJB7dvsAEUsUmoCbx5cth
	9i5GDg4RAX2JthYNkDCzQKnE1gfvWUBsIYFiiXctO8EWcAo4SDzb0wC2QFjAR+Lo5YlgNSwC
	qhK/Ti8Fq+EVsJX41bqSDcIWlPgx+R4LxEwtifU7jzNB2PISm9e8ZQZZKyGgLvHory5IWETA
	SGLR3nNQ5SIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1
	kvNzNzGC4/aZ9A7GVQ0WhxgFOBiVeHgbVmoFCrEmlhVX5h5ilOBgVhLh1QwFCvGmJFZWpRbl
	xxeV5qQWH2JMBnp0IrOUaHI+MKXklcQbGpuYGVkamVkYmZibkyasJM7LeOpJgJBAemJJanZq
	akFqEcwWJg5OqQbGjRuk/K5sYtxz4PvP7rUJqesYC4W4+i2/PbWtnPbxp6RM17Ejh0TSouJX
	hjgJve3fpGK/c9vW20fyp195Upzx0drx/FXP3q8Hz7pNXDODuXXZmXMHvvZJccfPtVPzsGZP
	v6Hrciu0apV2P/fdpPo1knX8Qik/WAxO2yYV7tdYuHnq5/rpSz8GKLEUZyQaajEXFScCAEw3
	FAwfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 23, 2013 6:26 AM, Andrew Morton wrote:
> 
> On Fri, 22 Feb 2013 19:42:59 +0900
> Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > Instead of using legacy suspend/resume methods, using newer dev_pm_ops
> > structure allows better control over power management.
> >
> > ...
> >
> > @@ -571,12 +571,13 @@ static struct spi_driver ams369fg06_driver = {
> >  	.driver = {
> >  		.name	= "ams369fg06",
> >  		.owner	= THIS_MODULE,
> > +#ifdef CONFIG_PM
> > +		.pm	= &ams369fg06_pm_ops,
> > +#endif
> >  	},
> >  	.probe		= ams369fg06_probe,
> >  	.remove		= ams369fg06_remove,
> >  	.shutdown	= ams369fg06_shutdown,
> 
> Are the ifdefs needed?  There's various macro trickery in pm.h to clean
> this up - the rtc drivers use it.

OK, you're right.
I will remove unnecessary '#ifdef CONFIG_PM'.
Thank you for your comment.

Best regards,
Jingoo Han



