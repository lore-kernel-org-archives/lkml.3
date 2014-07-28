Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaG1DJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:09:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23356 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaG1DJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:09:43 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-f4-53d5bef58967
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, t.figa@samsung.com, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
 <1404878455-31518-4-git-send-email-pankaj.dubey@samsung.com>
 <067501cfa7bd$8e6cb460$ab461d20$@samsung.com>
 <000501cfa7c9$e59f4840$b0ddd8c0$@samsung.com> <53D238E1.3030901@gmail.com>
In-reply-to: <53D238E1.3030901@gmail.com>
Subject: RE: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
Date: Mon, 28 Jul 2014 08:40:52 +0530
Message-id: <002601cfaa11$93de5060$bb9af120$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQC8Xg2wTqZTg6oaD/ugBpVTcwknCgI5HA+5AVmN/+ICfH9gYgHGy3ISnZyzeQA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsWyRsSkWvfrvqvBBo/b1SyWTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/Vov1M16zWHQsY7RYtesPo8XNZ9uZHHg8
	Wpp72Dx2zrrL7rF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZbReZi34zVNxYpJ3A+Nc
	ri5GDg4JAROJmzccuhg5gUwxiQv31rN1MXJxCAksZZTYP/knM0TCROJy+zEWiMR0RolVi69B
	OX8ZJV7saWABqWIT0JV48n4uM0hCRGAXo8TpC63sIA6zwEJGiWd3z0K1tDBJfPi/nA2khVNA
	U+Li8s9gS4QFQiVm7TzHBGKzCKhK3J9ymR3E5hWwlJjdsoERwhaU+DH5Htg6ZgEtifU7jzNB
	2PISm9e8hTpWQWLH2ddg9SICfhJPjrVB1YtLTHrwEOwiCYFODokNP+4wQiwTkPg2+RALJDRk
	JTYdgJojKXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kbFecWJucWleul5y
	fu4mRmC0n/73rH8H490D1ocYk4HWT2SWEk3OByaLvJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9M
	ChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmGDx5Pq337MUnyjINrg3/FfQMVPq8Mr7HnTW
	U9bEc/pd6XO8erN/r91R9lQgtmDptddGJhkJQes1uIQ4231uKehrx12793peBsOlb4sNHxj4
	OZi8WPLFr8J42tbzK6MP7tz3o8rOTvdhTVLWb5dld4u2h1/8cHeS9tImd8n1e9RMzwu3Ra/n
	V2Ipzkg01GIuKk4EAE0VbS8MAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd2v+64GG2w4KWOxbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1qsn/GaxaJjGaPFql1/GC1uPtvO5MDj
	0dLcw+axc9Zddo/NS+o9+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWNG62XWgt88FScmeTcwzuXqYuTkkBAwkbjcfowFwhaTuHBvPVsXIxeHkMB0RolV
	i6+xQDh/GSVe7GkAq2IT0JV48n4uM0hCRGAXo8TpC63sIA6zwEJGiWd3z0K1tDBJfPi/nA2k
	hVNAU+Li8s/MILawQKjErJ3nmEBsFgFViftTLrOD2LwClhKzWzYwQtiCEj8m3wNbxyygJbF+
	53EmCFteYvOat8wQxypI7Dj7GqxeRMBP4smxNqh6cYlJDx6yT2AUmoVk1Cwko2YhGTULScsC
	RpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHJ5JnUDsaVDRaHGAU4GJV4eC2CrwYLsSaW
	FVfmHmKU4GBWEuF92Q4U4k1JrKxKLcqPLyrNSS0+xGgK9OlEZinR5HxgossriTc0NjE3NTa1
	NLEwMbNUEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cBYvWTC+93PM9zqlE6uXxYTx6EYufDe
	5PDU6vmcn3rvsr/8z+Bv7ephF9fU8Tr5o0KC+v1zHFPWHAzTf6GsWfn03OuMv0/vq8/yuB9X
	lRUprr2q8Juxwe6DcuGa9+/HSDKtWVfLeHSp8zwF5RU79NoFGBwbLHJ27FGbsSOdxXXSpmee
	K1OfnohWYinOSDTUYi4qTgQA9DQcnzwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Friday, July 25, 2014 Tomasz Figa wrote:

> To: Pankaj Dubey; 'Kukjin Kim'; linux-arm-kernel@lists.infradead.org;
linux-
> samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: linux@arm.linux.org.uk; t.figa@samsung.com; vikas.sajjan@samsung.com;
> joshi@samsung.com; naushad@samsung.com; thomas.ab@samsung.com;
> chow.kim@samsung.com
> Subject: Re: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for
> Exynos PMU
> 
> Hi Pankaj, Kukjin,
> 
> On 25.07.2014 07:32, Pankaj Dubey wrote:
> > Hi Kukjin,
> >
> > On Friday, July 25, 2014 Kukjin Kim wrote:
> 
> [snip]
> 
> >>>
> >> Looks good to me, will apply this and 4/4.
> >>
> >
> > We need to hold these two patches until dependent patch [1] from
> > Tomasz Figa gets merged.
> >
> > [1]: mfd: syscon: Decouple syscon interface from syscon devices
> >       https://lkml.org/lkml/2014/6/24/188
> 
> That RFC patch had few comments from Arnd needed to be addressed, so it
needs a
> new revision.
> 
> Pankaj, If I remember correctly, we had talked about this and the
conclusion was that
> you would take care of addressing the comments and sending new version of
the
> patch. Any update on this or have I missed something?
> 

Well, I don't think we concluded as such anything.
Since this patch needs to get in so that Exynos PMU and PM related changes
can go in,
I discussed with you saying that I am not able to understand about Arnd's
comments and
if possible and time permits I will look into it. Meanwhile I got busy with
some other
official work, so could not get time to look into it.


> Best regards,
> Tomasz

