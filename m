Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3HBF5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:57:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35358 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3HBF5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:57:15 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a6-51fb4a3aa12f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <000601ce8f44$299805e0$7cc811a0$@samsung.com>
 <CAK9yfHyiM=jq7MmJoyBd0sn2ESSGZ4T4YvYLU899tOpU2=AZ+A@mail.gmail.com>
In-reply-to: <CAK9yfHyiM=jq7MmJoyBd0sn2ESSGZ4T4YvYLU899tOpU2=AZ+A@mail.gmail.com>
Subject: Re: [PATCH] mfd: menelaus: use NULL instead of 0
Date: Fri, 02 Aug 2013 14:57:14 +0900
Message-id: <000701ce8f45$22f32ac0$68d98040$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJkz4b3laB2zl88rAS1qy3uOAX9NANApZT8mDrlfDA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zA10rr9+BBh23ZS0uL7zEanH/61FG
	i8u75rBZnPzTy2hxupvVgdXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aO
	lU2MBWuZK9Y/aWFvYFzB1MXIySEhYCJx/uxGZghbTOLCvfVsXYxcHEICyxglXj1awtjFyAFW
	1PI6GSK+iFGi7dFPRgjnF6PEl65OsG42ATWJL18Os4PYIgI6Eit2rWUCKWIWmMAoMefNZqiO
	BkaJlzvfs4GM5RQIllh7nBekQVjAUmJ29yKwk1gEVCWebH3LAmLzAsU/dHcwQtiCEj8m3wOL
	MwtoSazfeZwJwpaX2LzmLdQLChI7zr5mhDjCSuL5rKfMEDUiEvtevGOEqLnELrF2VjXELgGJ
	b5MPsUB8KSux6QDUGEmJgytusABdPgvJ5llINs9CsnkWkg0LGFlWMYqmFiQXFCelF5nqFSfm
	Fpfmpesl5+duYoRE58QdjPcPWB9iTAZaP5FZSjQ5HxjdeSXxhsZmRhamJqbGRuaWZqQJK4nz
	qrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgrNq37ujL7V/nukYuWt9ldSWP/XbQgaht
	fikipWeZ1kSf/7Yln8Uij13FgE+/148xLkE/pKP4VHBzncc6iStGFn9z5FJbP12oiZqQufzd
	V8E3AqfCa1Iff0xSueaQxyQVNWd7wr5p3Rlmb+baKWiUP+PdsqnXZKa6fv+T+IvpnHsllfsX
	tQsqsRRnJBpqMRcVJwIAXxjWV+QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAV0rr9+BBtM6pSwuL7zEanH/61FG
	i8u75rBZnPzTy2hxupvVgdXjzrU9bB7zTgZ69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhHWPGjpVNjAVrmSvWP2lhb2BcwdTFyMEhIWAi0fI6uYuRE8gU
	k7hwbz1bFyMXh5DAIkaJtkc/GSGcX4wSX7o6mUGq2ATUJL58OcwOYosI6Eis2LWWCaSIWWAC
	o8ScN5uhOhoYJV7ufM8GsoJTIFhi7XFekAZhAUuJ2d2LmEBsFgFViSdb37KA2LxA8Q/dHYwQ
	tqDEj8n3wOLMAloS63ceZ4Kw5SU2r3nLDHGqgsSOs68ZIY6wkng+6ykzRI2IxL4X7xgnMArN
	QjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Oh/Jr2DcVWDxSFG
	AQ5GJR7eB5m/AoVYE8uKK3MPMUpwMCuJ8P6ZDRTiTUmsrEotyo8vKs1JLT7EmAz06URmKdHk
	fGBiyiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxjkN+6V1
	OXbvEImaXZmWN0dF69/+/nltz3IlTn24LPHSrK7NutnJp37q/kfX2+2/9vjvm/qrqekC19cK
	48OqJ9/wnsnld7nj7T+zN6TVPvpR2VHfsw8OGht+yNKXklx+90b7jNNrJdez77/zdPo/Lwu+
	I4nTTstxiq8r/OpRY/JVdcFUnZWOMUosxRmJhlrMRcWJAEHIILhCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 2:53 PM, Sachin Kamat wrote:
> On 2 August 2013 11:20, Jingoo Han <jg1.han@samsung.com> wrote:

[...]

> >
> >         mutex_lock(&the_menelaus->lock);
> > -       if (vtg == 0)
> > +       if (vtg == NULL)
> 
> Instead you could just make this:
>             if (!vtg)

Thank you for your comment. :)
It looks simpler. So, I will use it as you guide.

Best regards,
Jingoo Han



