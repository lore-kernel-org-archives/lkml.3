Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3DWE3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:29:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63339 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3DWE3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:29:40 -0400
X-AuditID: cbfee68d-b7feb6d000007be8-89-51760e33f468
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: <007101ce3fce$894d9920$9be8cb60$%choi@samsung.com>
 <20130423030842.GA24495@kroah.com>
In-reply-to: <20130423030842.GA24495@kroah.com>
Subject: RE: [PATCH 3.8-stable] ARM: S3C24XX: Correct NR_IRQS definition for
 s3c2440
Date: Tue, 23 Apr 2013 13:29:38 +0900
Message-id: <000801ce3fdb$2ad3bbb0$807b3310$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4/z/O3r1eJY5KGR5miAjozZdtyCwACbWog
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA11jvrJAg9ZmaYvmxevZLHoXXGWz
	uLxrDpvF4TftrBYLNj5itFi16w+jA5vHzll32T32z13D7tG3ZRWjx+dNcgEsUVw2Kak5mWWp
	Rfp2CVwZWydtZy44ylFxfO0ClgbGV2xdjJwcEgImEh+e/WeGsMUkLtxbDxTn4hASWMYocePW
	OqYuRg6won1noyHiixglWn/cYIVw/jJK3Nn/ix2km01AV+LY+i2sILaIgJbEs2M7mEGKmAV2
	MEo0fjgPtk5IIFni+KyJYDangL7EjoX3wJqFBcIk1hw9yghiswioSuz6vYIRZDOvgJ3Eq1tl
	IGFeAUGJH5PvsYDYzEDz1+88zgRhy0tsXvOWGeJQdYlHf3UhTjCSONH2gxWiRERi34t3jCDn
	SAg8YpfYOus3K8QqAYlvkw+xQPTKSmw6AA0ISYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyr
	GEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUIitXcH4+0D1ocYk4HWT2SWEk3OB0Z6Xkm8obGZ
	kYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYp4os3aHrN6tS
	uSnm853AvKUqAnPU7l1vOxBUVCfY+7zO8MDp+/lZ3+uMq3+Zhl9jmH663PrIEdZnS1yPn33J
	XdYd4f5Rkbch6VlPvsflnrvntqy6a6Ez2/JTVOsvOffinWI+5rM1+pPtXk199OGg4UL3SK1u
	u5oyTpGDJrluve/fXPkr+i5diaU4I9FQi7moOBEAk32akuoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV1jvrJAg5uPxCyaF69ns+hdcJXN
	4vKuOWwWh9+0s1os2PiI0WLVrj+MDmweO2fdZffYP3cNu0ffllWMHp83yQWwRDUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZmydtJ254ChHxfG1C1gaGF+xdTFycEgImEjs
	OxvdxcgJZIpJXLi3HijMxSEksIhRovXHDVYI5y+jxJ39v9hBqtgEdCWOrd/CCmKLCGhJPDu2
	gxmkiFlgB6NE44fzbCAJIYFkieOzJoLZnAL6EjsW3gNrFhYIk1hz9CgjiM0ioCqx6/cKRpAr
	eAXsJF7dKgMJ8woISvyYfI8FxGYGmr9+53EmCFteYvOat8wQR6tLPPqrC3GCkcSJth+sECUi
	EvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgtPA
	M6kdjCsbLA4xCnAwKvHwCriXBgqxJpYVV+YeYpTgYFYS4RXNBwrxpiRWVqUW5ccXleakFh9i
	TAb6cyKzlGhyPjBF5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMH
	p1QDY/wEZ713XdU/MsRE5959InbwcK6MgmrqXXlDl9tFh1a+cd78Ial72subM0505M/NnVrA
	2rRl4nXvhr/3Lz+O/re/3PlIere54NV9BjfOtgux1u+onDw5wuDW28AF7nEX387PP7vC7JzX
	JYnN3/ktX+/ME1gwqXvh2ckXIz5kKRWaxqmkm6exJSixFGckGmoxFxUnAgDkY0hsRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh my god~.

Maybe I was insane
When I send emails, I usually photocopy this part and use it,
but I accidently made a mistake.
I am so so sorry.

Best Regards.

Thanks.

> -----Original Message-----
> From: stable-owner@vger.kernel.org [mailto:stable-owner@vger.kernel.org]
> On Behalf Of Greg KH
> Sent: Tuesday, April 23, 2013 12:09 PM
> To: Jonghwan Choi
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; 'Sylwester
> Nawrocki'; 'Kukjin Kim'; 'Tomasz Figa'
> Subject: Re: [PATCH 3.8-stable] ARM: S3C24XX: Correct NR_IRQS definition
> for s3c2440
> 
> On Tue, Apr 23, 2013 at 11:59:13AM +0900, Jonghwan Choi wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me
> know.
> 
> Why, what are you going to do with this?  :)
> 
> I thought you were going to change the wording of your emails, what
> happened?
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

