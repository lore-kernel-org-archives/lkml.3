Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaDEKkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 06:40:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10553 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaDEKkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 06:40:40 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-ea-533fdda654dd
Message-id: <533FE1BC.7050300@samsung.com>
Date: Sat, 05 Apr 2014 19:58:04 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: Re: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
 <533BF905.6070701@samsung.com> <533BFF69.1060701@monstr.eu>
 <533D24D6.2030103@samsung.com>
In-reply-to: <533D24D6.2030103@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zQ91ld+2DDd7dMrJYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1ePLxNIvF4TftrBY7WlazOHB6tDT3sHlsXlLv8bdrCrNH
	35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZVw65lgwg61iYtcNtgbGryxdjJwcEgImEsvWfmCC
	sMUkLtxbz9bFyMUhJLCMUeLirlNwRa2fP7FAJBYxSly/85YVwnnNKDHl6yFWkCpeAS2JaR0L
	2bsYOThYBFQlZj+rAAmzCehKPHk/lxnEFhUIk9g0vQ+qXFDix+R7YAtEBPQllqy6CLaZWeAD
	o8Tvl8/AThIWiJSYffoFO8SyJ4wSC9p/gE3iFNCWWLJ+B1g3s4C1xMpJ2xghbHmJzWveMoM0
	SAjcYpfoXb2AHSTBIiAg8W3yIRaQ6yQEZCU2HWCGeE1S4uCKGywTGMVmITlqFpKxs5CMXcDI
	vIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJBJ7dzDePmB9iDEZaOVEZinR5HxgJOeVxBsa
	mxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Ou1uZ5xv7b
	I1WC4iwymQ/t+HP7K4vEr4CXjiUfn1lu2XXnwM6HXXIF3zW+7CjonJRTl5cUe9lH4lRZaKNW
	/MXXJnyy9VMzGh7U/A+PSu+okZlu9eGiePD8XT2+ru5zPKTv2R5xjm1M+MB868x+rXmlRqoN
	4dH317jlGMhvL5v79O0FtR8HnJVYijMSDbWYi4oTAYu/tnnaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd1ld+2DDa4u0rNYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1ePLxNIvF4TftrBY7WlazOHB6tDT3sHlsXlLv8bdrCrNH
	35ZVjB6fN8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8y4dMyxYAZb
	xcSuG2wNjF9Zuhg5OSQETCRaP3+CssUkLtxbz9bFyMUhJLCIUeL6nbesEM5rRokpXw+xglTx
	CmhJTOtYyN7FyMHBIqAqMftZBUiYTUBX4sn7ucwgtqhAmMSm6X1Q5YISPybfA1sgIqAvsWTV
	RbAFzAIfGCV+v3zGBJIQFoiUmH36BTvEsieMEgvaf4BN4hTQlliyfgdYN7OAtcTKSdsYIWx5
	ic1r3jJPYBSYhWTJLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHOfPpHcw
	rmqwOMQowMGoxMPbscMuWIg1say4MvcQowQHs5IIb8c5+2Ah3pTEyqrUovz4otKc1OJDjMnA
	IJjILCWanA9MQXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wJjkLZQl4vhkj4uqlh/r+rnc2n7v3ujeYlqVfCbyR27yD+eTt22eF81mEJjxps069jJf4RS5
	efwJoZyhgVYnTjx2ujR72Yqy6f8NJ/que3dZrydE+KFF/BvmbXFb6lsWJKw+2S7B9qSvTq7l
	nUXSNqkgZwmJl97Jms5PZmx/+udTaVIYK6fkJiWW4oxEQy3mouJEAMoCmlo3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 06:07 PM, Sylwester Nawrocki wrote:
> On 02/04/14 14:15, Michal Simek wrote:
>>> There were some patches posted for syscon to make it available in earlier
>>> system initialization stage: https://lkml.org/lkml/2014/2/19/218
>> I haven't finished this yet. I have to look at it again.
> Thanks for the information, I assume this would be also useful
> on the Exynos SoC series, so I'd be happy to see continuation
> of those works.

It is useful for Exynos SoC series and I have modified this patch series to use 
early syscon
initialization API and I can see it's working.
I have some observation for early initialization of syscon API which I will
update in corresponding message thread.

> --
> Thanks,
> Sylwester
>


-- 
Best Regards,
Pankaj Dubey

