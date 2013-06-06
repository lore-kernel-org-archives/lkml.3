Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3FFGy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 02:54:26 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33282 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3FFGyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 02:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <51AF60C1.9050409@semaphore.gr>
References: <51AF60C1.9050409@semaphore.gr>
Date: Thu, 6 Jun 2013 12:24:09 +0530
Message-ID: <CAKohpokYqXD9owu2-dDgo_+8bq702RqEEeVraPNSyeaNxcha_Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] cpufreq: ondemand: Change the calculation of
 target frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@suse.de>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2013 21:31, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Changes since v2:
>         - Reorder patches 2/3 and 3/3
>         - Fix typos in patch changelog
>
> Changes since v1:
>         - Use policy->cpuinfo.max_freq in the calculation formula
>                 of target frequency instead of policy->max
>         - Split the patch into 3 parts
>
> Stratos Karafotis (3):
>   cpufreq: ondemand: Change the calculation of target frequency
>   cpufreq: Remove unused APERF/MPERF support
>   cpufreq: Remove unused function __cpufreq_driver_getavg
>
>  arch/x86/include/asm/processor.h   | 29 ----------------------
>  drivers/cpufreq/Makefile           |  2 +-
>  drivers/cpufreq/acpi-cpufreq.c     |  5 ----
>  drivers/cpufreq/cpufreq.c          | 12 ---------
>  drivers/cpufreq/cpufreq_governor.c | 10 +-------
>  drivers/cpufreq/cpufreq_governor.h |  1 -
>  drivers/cpufreq/cpufreq_ondemand.c | 39 ++++++-----------------------
>  drivers/cpufreq/mperf.c            | 51 --------------------------------------
>  drivers/cpufreq/mperf.h            |  9 -------
>  include/linux/cpufreq.h            |  6 -----
>  10 files changed, 9 insertions(+), 155 deletions(-)
>  delete mode 100644 drivers/cpufreq/mperf.c
>  delete mode 100644 drivers/cpufreq/mperf.h

Functionally your patchset looks fine to me.. I know there are few
concerns about the real impact on power/performance, and I am
not talking about them here (Though they are very important :) ).

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
