Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3ILNdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:33:49 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:44319 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3ILNdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130912115710.25951.98497.stgit@srivatsabhat.in.ibm.com>
References: <20130912115710.25951.98497.stgit@srivatsabhat.in.ibm.com>
Date: Thu, 12 Sep 2013 19:03:47 +0530
Message-ID: <CAKohponfLQnPhpLwkOBQ--AXnmD+bvZ85iKQBts1c1wEZmBZuQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Detect spurious invocations of update_policy_cpu()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 17:29, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> The function update_policy_cpu() is expected to be called when the policy->cpu
> of a cpufreq policy is to be changed: ie., the new CPU nominated to become the
> policy->cpu is different from the old one.
>
> Print a warning if it is invoked with new_cpu == old_cpu, since such an
> invocation might hint at a faulty logic in the caller.
>
> Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
