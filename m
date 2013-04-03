Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579Ab3DCEfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 00:35:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28178 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760338Ab3DCEfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 00:35:21 -0400
X-AuditID: cbfee68d-b7f786d000005188-23-515bb186394a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Abhilash Kesavan'" <kesavan.abhilash@gmail.com>,
        myungjoo.ham@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        =?ks_c_5601-1987?B?J7nasOa5zic=?= <kyungmin.park@samsung.com>,
        rjw@sisk.pl,
        =?ks_c_5601-1987?B?J8PWwb7Iryc=?= <jhbird.choi@samsung.com>
References: <17352980.268481359965953092.JavaMail.weblogic@epml13>
 <CAM4voakFpXwG7ukO5p4=NKDQZc--rcLDPU8jGag_gB=4ZdvRAA@mail.gmail.com>
In-reply-to: <CAM4voakFpXwG7ukO5p4=NKDQZc--rcLDPU8jGag_gB=4ZdvRAA@mail.gmail.com>
Subject: RE: Re: [PATCH v4 4/4] PM: Devfreq: Add Exynos5-bus devfreq driver for
 Exynos5250
Date: Wed, 03 Apr 2013 13:35:18 +0900
Message-id: <24d701ce3024$a52d5310$ef87f930$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4CsgAiaqx1DqHoRTWB+w0gCsUtJQtcWUXA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zI922jdGBBv3LLS2WNHNbrPmrZHG2
	6Q27xeVdc9gsPvceYbS43biCzaJ/YS+TA7vHzll32T36tqxi9Hi0uIXR4/MmuQCWKC6blNSc
	zLLUIn27BK6M19cOMhbM4KjoWDSZsYFxNVsXIweHhICJxPr/nl2MnECmmMSFe+uBwlwcQgLL
	GCXeP3jDApEwkXh57ThUYjqjxKM5u1kgnL+MEpM2/AOrYhPQkDj8/hk7yFQRAV+Jy5MlQGqY
	BY4zSlzpuwvV3ckocbD1JStIA6dAsMT900dYQBqEBWIkDh8OAAmzCKhK9L8+wwxi8wrYSpz/
	v5wJwhaU+DH5HtguZgEDifez+lghbHmJzWveMkN8oy7x6K8uSFhEwEji0PFrTBAlIhL7Xrxj
	BDlBQuAlu0TLo0uMELsEJL5NPsQC0SsrsekAM8TDkhIHV9xgmcAoMQvJ5llINs9CsnkWkhUL
	GFlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoTEa+8OxtsHrA8xJgOtn8gsJZqcD4z3vJJ4
	Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwFtwS2m4Q
	475u9r4DSwxerAlOn++z/e/cg7P81J8ZSlrv/bFZbt/pJ9EV77SyWeRXvbFJnSL/rWjSuSU6
	HhIfwm2nvjt71+ZtmIp3TMPJe4nMxvnesxeYbsh74zUvQH37jKB0ti0am9onL5bKW5qw01Tv
	iOyqrfXi/hJfPvu7yuRoSDbbVW9XV2Ipzkg01GIuKk4EAGV1qrXtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQd22jdGBBqtum1gsaea2WPNXyeJs
	0xt2i8u75rBZfO49wmhxu3EFm0X/wl4mB3aPnbPusnv0bVnF6PFocQujx+dNcgEsUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlABygplCXmlAKF
	AhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM15fO8hYMIOjomPRZMYGxtVsXYycHBIC
	JhIvrx2HssUkLtxbD2RzcQgJTGeUeDRnNwuE85dRYtKGfywgVWwCGhKH3z9j72Lk4BAR8JW4
	PFkCpIZZ4DijxJW+u1DdnYwSB1tfsoI0cAoES9w/fYQFpEFYIEbi8OEAkDCLgKpE/+szzCA2
	r4CtxPn/y5kgbEGJH5Pvge1iFjCQeD+rjxXClpfYvOYtM8gYCQF1iUd/dUHCIgJGEoeOX2OC
	KBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	nA6eSe9gXNVgcYhRgINRiYf3xJeoQCHWxLLiytxDjBIczEoivKfDogOFeFMSK6tSi/Lji0pz
	UosPMSYDPTqRWUo0OR+YqvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoE
	s4WJg1OqgdExa9eiy4GHhd7fNf7yofPz8beK19d5/Z1veuOBycwJk5NrDhTVhTlOTbssatqz
	88N85u8iy5SqQ2Y6My3pe3QxqC5mupg129PTjwXv+0cz3nLc+iHpS1L4XrdSfzEhuUOXdt0w
	fdz4va02Pv2ZfGbum0clJ8/28bEpBSe8KHeI8thktkTz0CYlluKMREMt5qLiRADkrBjsSwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash Kesavan wrote:

> >> > One concern is that I cannot apply Patch 1/4 directly as the .dts
> file isn't
> >> > available to me.
> >> > Do you intend to apply that patch to another tree and apply the other
> three
> >> > to devfreq tree?
> >> I have been merging the devfreq tree into Kgene's tree for my testing.
> I am not
> >> sure how this should get in, any suggestions ?
> >
> > I'd suggest to send Patch 1/4 to Kgene and get it applied first if that
> patch is preliminary to the other patchset. If it is not, we can go
> seperated and independently.

> Thanks for the suggestion. Kgene is a recipient on patches 1 and 2. I
> am hoping he'll pick it up soon. However, the devfreq patches are not
> dependent on them and can be applied independently.

Just note, as I commented, arch side patches should be re-worked and
current devfreq in mainline won't cause any problems without the arch side.
And I discussed with Abhilash about that, he will finish arch side re-
posting next time.

Thanks.

- Kukjin

