Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3BVHum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:50:42 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45560 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab3BVHuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:50:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAP245DVYsjgvww-3qBnbZ4T7SsJ=whbVvhf06fArxcspyX9bwQ@mail.gmail.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
	<1361512604-2720-2-git-send-email-khilman@linaro.org>
	<CAOh2x=kFL5_H=LqLf14yxYQEs7zSTT8Ue8mjUEVN4_a0c53Rdg@mail.gmail.com>
	<CAP245DVYsjgvww-3qBnbZ4T7SsJ=whbVvhf06fArxcspyX9bwQ@mail.gmail.com>
Date: Fri, 22 Feb 2013 13:20:25 +0530
Message-ID: <CAKohpomx8B+=XhC=WFo0ZtEMM-DuBfwyMSKE4-Ng=5gyGGCxWg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpustat: use accessor functions for get/set/add
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Lists LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 12:47, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On Fri, Feb 22, 2013 at 11:51 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> BTW, i don't see kcpustat_cpu() used in
>>
>>  kernel/sched/core.c                | 12 +++++-------
>>  kernel/sched/cputime.c             | 29 +++++++++++++--------------
>>
>> I searched tip/master as well as lnext/master.
>
> Added by Frederic's Adaptive NOHZ patchset?

I don't even see them on our unused-nohz-adaptive-tickless-v2 branch :)
Maybe some other latest work.
