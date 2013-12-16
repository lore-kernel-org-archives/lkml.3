Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3LPJN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:13:26 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33944 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3LPJNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:13:23 -0500
MIME-Version: 1.0
In-Reply-To: <1385642562-9339-1-git-send-email-l.majewski@samsung.com>
References: <1381939238-30398-1-git-send-email-t.figa@samsung.com>
	<1385642562-9339-1-git-send-email-l.majewski@samsung.com>
Date: Mon, 16 Dec 2013 14:43:23 +0530
Message-ID: <CAKohpongZr8CTjQr_MeWb14tMST4D+j_GxU2vF=0AiL6sTsQ0w@mail.gmail.com>
Subject: Re: [PATCH v3] cpufreq: exynos: Convert exynos-cpufreq to platform driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 November 2013 18:12, Lukasz Majewski <l.majewski@samsung.com> wrote:
> To make the driver multiplatform-friendly, unconditional initialization
> in an initcall is replaced with a platform driver probed only if
> respective platform device is registered.
>
> Tested at: Exynos4210 (TRATS) and Exynos4412 (TRATS2)
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> ---
> Changes for v3:
> - Rename exynos_cpufreq_init() to exynos_cpufreq_probe()
>
> Changes for v2:
> - Proper definition of exynos_cpufreq_init() function to squash warnings
>
>  arch/arm/mach-exynos/common.c          |    5 +++++
>  arch/arm/mach-exynos/common.h          |    1 +
>  arch/arm/mach-exynos/mach-exynos4-dt.c |    1 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c |    1 +
>  drivers/cpufreq/exynos-cpufreq.c       |   13 +++++++++++--
>  5 files changed, 19 insertions(+), 2 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
