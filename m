Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaJVG0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:26:31 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:59471 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaJVG0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:26:30 -0400
MIME-Version: 1.0
In-Reply-To: <1413958051-7103-5-git-send-email-mturquette@linaro.org>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
	<1413958051-7103-5-git-send-email-mturquette@linaro.org>
Date: Wed, 22 Oct 2014 11:56:29 +0530
Message-ID: <CAKohpokx2bKYX3-+UdXkVdvcEgqn9DdN8QUKhY9ohFiA5DCH6A@mail.gmail.com>
Subject: Re: [PATCH RFC 4/7] cpufreq: add per-governor private data
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        kamalesh@linux.vnet.ibm.com, riel@redhat.com, efault@gmx.de,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, bsegall@google.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2014 11:37, Mike Turquette <mturquette@linaro.org> wrote:
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>  include/linux/cpufreq.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 138336b..91d173c 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -115,6 +115,9 @@ struct cpufreq_policy {
>
>         /* For cpufreq driver's internal use */
>         void                    *driver_data;
> +
> +       /* For cpufreq governor's internal use */
> +       void                    *gov_data;

Its already there: governor_data ..

Am I missing something ?
