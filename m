Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab3ILKFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:05:42 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:37740 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3ILKFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:05:38 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1378963070.git.viresh.kumar@linaro.org>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
Date: Thu, 12 Sep 2013 15:35:37 +0530
Message-ID: <CAKohpomDbrtvG95oQKvwO=KpLF7fmJDZ4_iEQ=rPAT3e_16FMw@mail.gmail.com>
Subject: Re: [PATCH 0/5] cpufreq: Last minute fixes for 3.12
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 10:55, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> First three of the patchset are minor cleanups (you may or may not take them for
> 3.12), but last two are some real fixes.. I haven't faced any issue without them
> but simply found them in code review.

> Viresh Kumar (5):
>   cpufreq: Remove extra blank line
>   cpufreq: don't break string in print statements
>   cpufreq: remove __cpufreq_remove_dev()
>   cpufreq: don't update policy->cpu while removing while removing other
>     CPUs
>   cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()

So in the end there is only one real fix in this series as 4/4/ is already in..

To make it clear again these are my pending patches for cpufreq:
For 3.12-rc2:
- 5/5 of this patchset (modified one)..
- "serialize freq transitions" that I will send separately today as Guennadi
has already tested that ..

For 3.13:
- First 3 patches from this series (I tried rebase them over your linux-next and
didn't found any issue)
- 5 patches from: http://www.gossamer-threads.com/lists/linux/kernel/1781051
- And the rest ~220 patches that I will send soon (Will rebase them
over all above
patches)..

Thanks.
Viresh
