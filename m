Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaIEHlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:41:25 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61476 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIEHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:41:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140905073812.3629.29175.stgit@preeti.in.ibm.com>
References: <20140905073812.3629.29175.stgit@preeti.in.ibm.com>
Date: Fri, 5 Sep 2014 13:11:22 +0530
Message-ID: <CAKohpo=chEW_TtXWCHa3OEwrqU25TPBES4icjMVxL6nezrf8+w@mail.gmail.com>
Subject: Re: [PATCH V2 0/2] cpufreq/powernv: Set core pstate to a minimum just
 before hotplugging it out
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Shreyas Prabhu <shreyas@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2014 13:09, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Today cpus go to winkle when they are offlined. Since it is the deepest
> idle state that we have, it is expected to save good amount of power as compared
> to online state, where cores can enter nap/fastsleep only which are
> shallower idle states.
> However we observed no powersavings with winkle as compared to nap/fastsleep
> and traced the problem to the pstate of the core being kept at a high even
> when the core is offline. This can keep the socket pstate high, thus burning
> power unnecessarily. This patchset fixes this issue.
>
> Changes in V2: Changed smp_call_function_any() to smp_call_function_single() in Patch[2/2]

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
