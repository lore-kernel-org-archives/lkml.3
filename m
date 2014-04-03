Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162550AbaDCJHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:07:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24431 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162296AbaDCJHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:07:44 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-b8-533d24de5751
Message-id: <533D24D6.2030103@samsung.com>
Date: Thu, 03 Apr 2014 11:07:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: monstr@monstr.eu
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: Re: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
 <533BF905.6070701@samsung.com> <533BFF69.1060701@monstr.eu>
In-reply-to: <533BFF69.1060701@monstr.eu>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7r3VGyDDbq+81ksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaPPl4msVi0dYv7BY7WlazOHB6tDT3sHlsXlLv8bdrCrNH
	35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZUx70cZWsIy5oqFpL2sD42WmLkZODgkBE4ndKx8y
	QthiEhfurWfrYuTiEBJYyigxp/cVI4TziVGie+9GsCpeAS2Jcx/b2LsYOThYBFQlbvaEg4TZ
	BAwleo/2gZWICkRI3Gs8zApRLijxY/I9FhBbREBEYsa9LcwgM5kF2pkk7v8+xQaSEBaIlJh9
	+gU7xLLDjBK/Lu0GS3AKaEocXN7NDmIzC+hI7G+dxgZhy0tsXvOWeQKjwCwkS2YhKZuFpGwB
	I/MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJDA/7KDcfExq0OMAhyMSjy8FlI2wUKsiWXF
	lbmHGCU4mJVEeC9+AQrxpiRWVqUW5ccXleakFh9iZOLglGpgZDk5gW/SxUmhFp7MnQcXO56c
	6WIvIafRUnEuNqM8Si9mbsojP3nW1mmR8u2GL7Vaoj5OfHxZSE/NvDL5hOI9vfp7bukfve/I
	POW8IxtyrX2muttJnavPxKyNbQvqWM7aWP6Z+65zTWbG2pVXHYuuFKb61srMZVD9otP2UPq0
	9nf5f+kiK94osRRnJBpqMRcVJwIAz8yR/FoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/14 14:15, Michal Simek wrote:
>> There were some patches posted for syscon to make it available in earlier
>> system initialization stage: https://lkml.org/lkml/2014/2/19/218
>
> I haven't finished this yet. I have to look at it again.

Thanks for the information, I assume this would be also useful
on the Exynos SoC series, so I'd be happy to see continuation
of those works.

--
Thanks,
Sylwester
