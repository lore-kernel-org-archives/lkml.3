Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaGHOcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:32:32 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8895 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaGHOc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:32:29 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-dd-53bc00fb18a6
Message-id: <53BC00DB.7020308@samsung.com>
Date: Tue, 08 Jul 2014 16:31:55 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v6 4/4] ARM: EXYNOS: Move PMU specific definitions from
 common.h
References: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
 <1404710376-16448-5-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1404710376-16448-5-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xq7q/GfYEG+xfrW6xbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1os2gpU0bGM0eLms+1MDtweLc09bB6b
	l9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bUr2+ZCtayVnR3v2JtYFzE0sXIySEhYCKx
	YtkkdghbTOLCvfVsXYxcHEICSxklPl7dzQjhfGaU2L/6IytIFa+AlsSlNf+ZQGwWAVWJth8H
	wLrZBNQkPjc8YgOx+YFq1jRdB9rAwSEqECHx+IIQRKugxI/J91hAZooITGOUuHjpNjuIwyyw
	hFFiz4xTjCBVwgJhEr+enGOF2NzOKPFj12uwbZwCnhLHDt9iBrGZBXQk9rdOY4Ow5SU2r3nL
	PIFRcBaSLbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkhsfNnBuPiY1SFG
	AQ5GJR5ejdrdwUKsiWXFlbmHGCU4mJVEeL+cAgrxpiRWVqUW5ccXleakFh9iZOLglGpgNPx7
	/ZfKiUWJ/IcU4jsvM9drLnK62iu3cnXfdq3ENS12c4rvi6ec0zpzhs9ghafgzow3C3f9r1Ur
	fZwZMKl79ULNw8maC58wysW5LnbceeDS0s83XLa0nvJfqH4zq409fVfq+c+Wfw2ufTzboHHR
	euf0Ix8OLd7vpiFq96yu9oaQfdafo+e+WSixFGckGmoxFxUnAgBjynuKawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.07.2014 07:19, Pankaj Dubey wrote:
> This patch moves PMU specific definitions into a new file
> as exynos-pmu.h.
> This will help in reducing dependency of common.h in pmu.c.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h     |   17 -----------------
>  arch/arm/mach-exynos/exynos-pmu.h |   24 ++++++++++++++++++++++++
>  arch/arm/mach-exynos/pm.c         |    1 +
>  arch/arm/mach-exynos/pmu.c        |   10 +++++++++-
>  4 files changed, 34 insertions(+), 18 deletions(-)
>  create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
> 

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
