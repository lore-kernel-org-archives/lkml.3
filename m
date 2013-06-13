Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab3FMW72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:59:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42059 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab3FMW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:59:26 -0400
X-AuditID: cbfee691-b7fef6d000002d62-9d-51ba4eccd8cf
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Cesar Eduardo Barros'" <cesarb@cesarb.net>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
 <1552010.DOo3aEBKyJ@flatron> <15cf01ce6884$8c073f20$a415bd60$%kim@samsung.com>
 <26381641.c4KnMQ8aS6@flatron>
In-reply-to: <26381641.c4KnMQ8aS6@flatron>
Subject: RE: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
Date: Fri, 14 Jun 2013 07:59:24 +0900
Message-id: <15df01ce6889$a5d522a0$f17f67e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5oheMTf4uTo/GYQ1GY7KQt9NBqHAAAiFXQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t8zfd0zfrsCDX7vkrWYs34Nm8Wsa0EW
	c863sFicXXaQzWLJz11MFlP+LGeyuLxrDpvFjPP7mCz2HD3MbnHq+mc2i617r7JbHJuxhNFi
	1a4/jA68Ho03brB5HLk9g9ljdsNFFo8pvzeyemxZeZPJY+esu+wed67tYfM4MeM3i8eVE02s
	Hu/3XWXz+LxJLoA7issmJTUnsyy1SN8ugStj+t3fLAULeCq2zH7B2MB4gLOLkZNDQsBEYseT
	YywQtpjEhXvr2boYuTiEBJYxSjyZe4wVpujrx4XsEInpjBJ/OmczQzh/GSUeb1/GBlLFJqAh
	cfj9M3YQW0RAU+LYk2dgHcwC01kkXkw/xQLRsY1RYsrsbcwgVZwCWhKz7+0DquLgEBawlXi7
	1w8kzCKgKrGs9Q3Yal6g8PMzs6BsQYkfk++B3coM1Lp+53EmCFteYvOat8wgYyQE1CUe/dWF
	uMFI4ufXTVAlIhL7XrxjBDlBQuAIh8SUZ9OZIHYJSHybfIgFoldWYtMBZoiPJSUOrrjBMoFR
	YhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAhJGxN3MN4/YH2I
	MRlo/URmKdHkfGDaySuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQn
	tfgQIxMHp1QDoziH5qS5XawTJ3TLT7uxeub93jVT2zPzKxnPlQW8OnuMcXdh6Ix3s16nLtzC
	b7VNieXS6xTfJWzdl+1n6Ubnbl+97sBuG6W+0JL+DQLGzgZZG1bNPLe02J1X5+VlrqdzWucs
	YLL+G3fwxFzrr22pvcxBK7P3hWUKLIqoaNi6fn6HX5C/z/bjP5VYijMSDbWYi4oTAX0LL6gx	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jQd0zfrsCDTYtFLeYs34Nm8Wsa0EW
	c863sFicXXaQzWLJz11MFlP+LGeyuLxrDpvFjPP7mCz2HD3MbnHq+mc2i617r7JbHJuxhNFi
	1a4/jA68Ho03brB5HLk9g9ljdsNFFo8pvzeyemxZeZPJY+esu+wed67tYfM4MeM3i8eVE02s
	Hu/3XWXz+LxJLoA7qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoBSWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxvS7v1kK
	FvBUbJn9grGB8QBnFyMnh4SAicTXjwvZIWwxiQv31rN1MXJxCAlMZ5T40zmbGcL5yyjxePsy
	NpAqNgENicPvn4F1iAhoShx7AmJzcTALTGeReDH9FAtExzZGiSmztzGDVHEKaEnMvrcPqIqD
	Q1jAVuLtXj+QMIuAqsSy1jesIDYvUPj5mVlQtqDEj8n3WEBsZqDW9TuPM0HY8hKb17xlBhkj
	IaAu8eivLsQNRhI/v26CKhGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRnJSeSe9gXNVgcYhRgINRiYc34cLOQCHWxLLiytxDjBIczEoivOF/
	gUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0yYeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1
	DhQSSE8sSc1OTS1ILYLZwsTBKdXAuOkPD2fXR8Olmz8aBE0WqhVIDAo9MEnqrOUJSy/LmMd7
	HWw/3752rMRZ5rWsdE1Q/UTXKSyB9ZP++YZcaNTJK2ybYntG89rWD5465v45/QV/w4+2LVZe
	33rqRnmTsedBs1Mey1ptdjU9WHH6gZZCqol3Iv+tHdWpX+6mRZhHFvz3Xy7eHlWpxFKckWio
	xVxUnAgATEmQv44DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 

[...]

> > > From my understanding how it works, there is no need to list Linus in
> > > particular drivers, because he's already listed as a maintainer of the
> > > whole pinctrl subsystem and get-maintainer accounts for this.
> > >
> > > Similarly for Kukjin, he's listed as the main Samsung maintainer
> > > already,
> > If so, the directory like pinctrl should be added under Samsung ARM
> > Architectures like spi and sound for Samsung stuff...
> 
> I don't think so, because it's a part of the pin control subsystem.
> 
Yes right. I mean, pinctrl is clos

> > > but AFAIK in this case the script can't infer this based on directory
> >
> > > structure. Let's see how it's done for other Samsung drivers:
> > Well, I don't think so, because pinctrl has the close relationship with
> > exynos arch part and it's little bit different with following. Just in
> > my understanding.
> 
> I'm not really sure what you mean. Pin control is a separate kernel
> subsystem, which shouldn't have any dependencies on arch code.
> 
Yes, right. I have no objection about it is a subsystem. I meant just
relationship and it helps people find the overall architecture.

[...]

> > And I'm asking above all guys _really_ do review and maintaining the
> > file or directories? I don't think so.
> 
> I'm not really sure what makes you think they don't. I can see all of them
> involved in works on mentioned drivers.
> 
What's the role of maintainer? I mean, as you said, above guys are really do
it...

- Kukjin

