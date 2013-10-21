Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3JUH3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 03:29:34 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:37750 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3JUH3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 03:29:32 -0400
MIME-Version: 1.0
In-Reply-To: <1381775807-20144-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1381775807-20144-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Date: Mon, 21 Oct 2013 12:59:30 +0530
Message-ID: <CAKohpom-KBME6fa3BUmKfZSgJxYngD7RG+CD3vHHKdtWtrtOxA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: s3c64xx: Rename index to driver_data
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 October 2013 00:06, Charles Keepax
<ckeepax@opensource.wolfsonmicro.com> wrote:
> The index field of cpufreq_frequency_table has been renamed to driver
> data in this commit:
>
> commit 5070158804b5339c71809f5e673cea1cfacd804d
> cpufreq: rename index as driver_data in cpufreq_frequency_table
>
> This patch updates the s3c64xx driver to match.
>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/cpufreq/s3c64xx-cpufreq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
> index 8a72b0c..15631f9 100644
> --- a/drivers/cpufreq/s3c64xx-cpufreq.c
> +++ b/drivers/cpufreq/s3c64xx-cpufreq.c
> @@ -166,7 +166,7 @@ static void __init s3c64xx_cpufreq_config_regulator(void)
>                 if (freq->frequency == CPUFREQ_ENTRY_INVALID)
>                         continue;
>
> -               dvfs = &s3c64xx_dvfs_table[freq->index];
> +               dvfs = &s3c64xx_dvfs_table[freq->driver_data];
>                 found = 0;
>
>                 for (i = 0; i < count; i++) {

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

@Rafael: Can you please get this in 3.12 as a bug fix?
