Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab3JWFlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 01:41:05 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:46662 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3JWFlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 01:41:04 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Date: Wed, 23 Oct 2013 11:11:02 +0530
Message-ID: <CAKohponte=P4NBM66yexeavcAoehDfzgOmYhZvxJoMzTnXd=mw@mail.gmail.com>
Subject: Re: [PATCH V2 00/16] CPUIdle: Minor cleanups for 3.13
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2013 21:26, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> These are V2 of my CPUIdle cleanup series.. Few patches are dropped as they
> required further modifications. Last one is rewritten as suggested by Daniel.
> Most of them are already Acked by Daniel.
>
> Viresh Kumar (16):
>   cpuidle: fix indentation of cpumask
>   cpuidle: Fix comments in cpuidle core
>   cpuidle: make __cpuidle_get_cpu_driver() inline
>   cpuidle: make __cpuidle_device_init() return void
>   cpuidle: make __cpuidle_driver_init() return void
>   cpuidle: rearrange code in __cpuidle_driver_init()
>   cpuidle: rearrange __cpuidle_register_device() to keep minimal exit
>     points
>   cpuidle: merge two if() statements for checking error cases
>   cpuidle: reduce code duplication inside cpuidle_idle_call()
>   cpuidle: replace multiline statements with single line in
>     cpuidle_idle_call()
>   cpuidle: call cpuidle_get_driver() from after taking
>     cpuidle_driver_lock
>   cpuidle: use drv instead of cpuidle_driver in show_current_driver()
>   cpuidle: free all state kobjects from cpuidle_free_state_kobj()
>   cpuidle: don't calculate time-diff if entered_state < 0
>   cpuidle: don't call poll_idle_init() for every cpu
>   cpuidle: remove cpuidle_unregister_governor()

Hi Rafael,

Any chance this can get in 3.13 ??
