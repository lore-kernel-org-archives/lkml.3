Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3K2FpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 00:45:23 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56566 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3K2FpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 00:45:21 -0500
MIME-Version: 1.0
In-Reply-To: <1385642562-9339-1-git-send-email-l.majewski@samsung.com>
References: <1381939238-30398-1-git-send-email-t.figa@samsung.com>
	<1385642562-9339-1-git-send-email-l.majewski@samsung.com>
Date: Fri, 29 Nov 2013 11:15:21 +0530
Message-ID: <CAK9yfHyFXHiTmYeS6N-rTktHPsXNC3SGE8-yyZW4i-txQXo1+w@mail.gmail.com>
Subject: Re: [PATCH v3] cpufreq: exynos: Convert exynos-cpufreq to platform driver
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>
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

Looks good to me.
Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>

Tested on Exynos5250 board.
Tested-by: Sachin Kamat <sachin.kamat@linaro.org>

Btw, Lukasz, can you please review my patch [1] which is similar to your
changes done for 4210/4412.

[1] http://www.spinics.net/lists/linux-samsung-soc/msg24397.html

-- 
With warm regards,
Sachin
