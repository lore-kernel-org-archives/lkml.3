Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaEVEz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:55:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24032 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaEVEz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:55:27 -0400
X-AuditID: cbfee690-b7fb56d000003439-5d-537d832ed829
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Shinya Kuribayashi'" <shinya.kuribayashi.px@renesas.com>,
        "'Magnus Damm'" <damm@opensource.se>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Joe Perches'" <joe@perches.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
 <002d01cf6384$a6dbcf90$f4936eb0$%han@samsung.com> <5379E177.2030707@linaro.org>
In-reply-to: <5379E177.2030707@linaro.org>
Subject: Re: [PATCH 1/4] clocksource: em_sti: remove unnecessary OOM messages
Date: Thu, 22 May 2014 13:55:20 +0900
Message-id: <001a01cf757a$087b4530$1971cf90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9zT9YuDAVYyP1JRSeiIWmPmmaeEACKA6Wg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t8zI1295tpggw+blCzmrF/DZnH/8S0m
	i9f/prNYzPssa3F54SVWi9n3H7NYdE5cwm5xedccNos3Rz0tNm+aymzxc9c8FouNXz0ceDx2
	zrrL7jG7Yyarx51re9g83p07x+5xYsZvFo+VPy6xe3x8eovF48uqa8we385MZPHo27KK0ePz
	JrkA7igum5TUnMyy1CJ9uwSujE/nf7AU/OSqmDRlM1MD4zmOLkZODgkBE4lvjR3MELaYxIV7
	69m6GLk4hASWMUrcP3sCyOEAK7rRlQcRn84ocXD7N6ii34wSO1/PZwLpZhNQk/jy5TA7iC0i
	YCDx+vRvdpAiZoH7zBL/399jgujoZ5SY9/8FK0gVp4CWxJy2y8wgK4QFfCU+7wM7iUVAVWLV
	4zdgg3gFbCXa991hgrAFJX5MvscCUs4soC4xZUouSJhZQF5i85q3zBCHqks8+qsLcYKRxKw7
	b1kgSkQk9r14xwhygYTAAQ6Jjcv2MkGsEpD4NvkQC0SvrMSmA9CAkJQ4uOIGywRGiVlIFs9C
	WDwLyeJZSDYsYGRZxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRGSIibsYLx3wPoQYzLQ9onM
	UqLJ+cAUk1cSb2hsZmRhamJqbGRuaUaasJI4r9qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjPNqyrZdcuLdEmLUJHv09q7a+sYPP5Z2rLSbf31BaJwQ+6fQfzM37TQ3jbNwzDm2JyP3
	N+PNaR8Wpm9X3v86ZZb3l29zOAKzrpZqTYwVPlVakNOYc/GECueiHWI8G6SnXb+9W6C/jV+o
	yXy18TqBqtBL59ds7V3muPRGvEmJbtnp7tv6M9SLOpRYijMSDbWYi4oTAfOnpbMnAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsVy+t9jQV295tpgg/NzZC3mrF/DZnH/8S0m
	i9f/prNYzPssa3F54SVWi9n3H7NYdE5cwm5xedccNos3Rz0tNm+aymzxc9c8FouNXz0ceDx2
	zrrL7jG7Yyarx51re9g83p07x+5xYsZvFo+VPy6xe3x8eovF48uqa8we385MZPHo27KK0ePz
	JrkA7qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wc
	oNuVFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmfzv9gKfjJVTFpymam
	BsZzHF2MHBwSAiYSN7ryuhg5gUwxiQv31rN1MXJxCAlMZ5Q4uP0blPObUWLn6/lMIFVsAmoS
	X74cZgexRQQMJF6f/s0OUsQscJ9Z4v/7e0wQHf2MEvP+v2AFqeIU0JKY03aZGWSdsICvxOd9
	HCBhFgFViVWP34AN4hWwlWjfd4cJwhaU+DH5HgtIObOAusSUKbkgYWYBeYnNa94yQxytLvHo
	ry7ECUYSs+68ZYEoEZHY9+Id4wRGoVlIBs1CGDQLyaBZSDoWMLKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAhOQM+kdzCuarA4xCjAwajEw3vjfE2wEGtiWXFl7iFGCQ5mJRHebTW1wUK8
	KYmVValF+fFFpTmpxYcYk4HenMgsJZqcD0yOeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQS
	SE8sSc1OTS1ILYLZwsTBKdXA2O3FWLBDXrX9PeMtsaTrsZ83KSywuc12nuWOiOKGCoYyg6cp
	9QHbw3080qc5sNzQ1VEvE2hkmeJ0Z61Bm9rTqOT4xtnx+Y8m8+/btHTdyaArx7VX59YUiMX8
	Wbqj1lTvsPT83pTqctVZy447zfx/Io53zRrlsH2eE7P3v/zOZMG9fEfEhh5bJZbijERDLeai
	4kQAUp/wSoQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 19, 2014 7:48 PM, Daniel Lezcano wrote:
> On 04/29/2014 10:26 AM, Jingoo Han wrote:
> > The site-specific OOM messages are unnecessary, because they
> > duplicate the MM subsystem generic OOM message.
> 
> Are you sure the MM subsys display a message when an allocation fails ?
> 
> There are multiple reasons an allocation can fail.

(+cc Viresh Kumar, Laurent Pinchart, Dan Carpenter, Joe Perches,
       Thierry Reding, Andrew Morton)

There was a discussion about this in other threads. [1]
Please refer to the following link. Thank you.

[1] http://patchwork.ozlabs.org/patch/324158/

Best regards,
Jingoo Han

> 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >   drivers/clocksource/em_sti.c |    4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
> > index 9d17083..d0a7bd6 100644
> > --- a/drivers/clocksource/em_sti.c
> > +++ b/drivers/clocksource/em_sti.c
> > @@ -318,10 +318,8 @@ static int em_sti_probe(struct platform_device *pdev)
> >   	int irq;
> >
> >   	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
> > -	if (p == NULL) {
> > -		dev_err(&pdev->dev, "failed to allocate driver data\n");
> > +	if (p == NULL)
> >   		return -ENOMEM;
> > -	}
> >
> >   	p->pdev = pdev;
> >   	platform_set_drvdata(pdev, p);
> >

