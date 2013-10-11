Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3JKGGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:06:43 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51406 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3JKGGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:06:41 -0400
MIME-Version: 1.0
In-Reply-To: <1381320523-28183-1-git-send-email-l.majewski@samsung.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
	<1381320523-28183-1-git-send-email-l.majewski@samsung.com>
Date: Fri, 11 Oct 2013 11:36:40 +0530
Message-ID: <CAKew6eVxk7nGKkiPz2HsfF-+V1fOVvZmd-zrU3qY_VZWD-grLQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] cpufreq: exynos: Fixes for v3.12
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 5:38 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> Attached commits provide cpufreq regression fixes for Trats and Trats2
> Exynos4 boards.
> Since v3.12 Exynos4 uses common clock framework for clock manipulation.
> Those patches restore correct output for cpuinfo_cur_freq [1] sysfs
> attribute.
> Without them, the [1] provides default frequency (800 MHz) set at driver
> initialization.
>
>
> Lukasz Majewski (2):
>   cpufreq: exynos4x12: Use the common clock framework to set APLL clock
>     rate
>   cpufreq: exynos4210: Use the common clock framework to set APLL clock
>     rate
>

Just as a fix for 3.12, these patches looks OK to me.

Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>


Regards,
Yadwinder

>  drivers/cpufreq/exynos4210-cpufreq.c |   67 ++++-----------------------------
>  drivers/cpufreq/exynos4x12-cpufreq.c |   69 ++++------------------------------
>  2 files changed, 16 insertions(+), 120 deletions(-)
>
> --
> 1.7.10.4
>
