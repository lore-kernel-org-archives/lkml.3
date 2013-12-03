Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3LCU3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:29:00 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:51141 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3LCU2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:28:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131203202249.GA21510@redhat.com>
References: <20131202152423.GA10878@redhat.com> <CAJ75kXYu943GxQpKGkpfmAj87YKbr1aoPu60zozik1MCkK7gag@mail.gmail.com>
 <20131203202249.GA21510@redhat.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Tue, 3 Dec 2013 21:28:33 +0100
Message-ID: <CAJ75kXbFfPcEQ5z8GQiZUJBSp+WA5n1BQhERGNky_CX3-AYtRA@mail.gmail.com>
Subject: Re: [PATCH 0/2] initial while_each_thread() fixes
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 9:22 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> Before this patch, I was testing this one
>> https://lkml.org/lkml/2013/11/13/336
>
> perhaps this patch makes more sense for stable.

I guess we should consider it.

> But, to clarify just in case, it is not needed after this series.
>
>> which is fixing my oom issues.
>
> Yes, but it doesn't fix all problems even in mm/oom_kill.c, and
> we need to fix while_each_thread() anyway.
>
>> I applied the two patches on top of a 3.10.x and got some tasks
>> stalled after the first OOM:
>
> So you are saying that this was introduced by this series?

yes, without thse two patches I can't reproduce my issue.

> Could you retest with the recent kernel?

I'll see if I find time for it; will keep you up to date.

Thanks,

-- 
William
