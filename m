Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3C2Cjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 22:39:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64811 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3C2Cju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 22:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130328181332.GD14088@htj.dyndns.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
	<20130321001211.GC31256@htj.dyndns.org>
	<CAKohponKUGbwEZ_edu353Y7YVZKgFOhZunTSUi04FGYWveftkw@mail.gmail.com>
	<20130321182937.GB20500@htj.dyndns.org>
	<20130328181332.GD14088@htj.dyndns.org>
Date: Fri, 29 Mar 2013 08:09:49 +0530
Message-ID: <CAKohpom1wbrfOgPr4n-HzQjdUS=BcHwbrd=gemVKr1QqEO0L9A@mail.gmail.com>
Subject: Re: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 23:43, Tejun Heo <tj@kernel.org> wrote:
> Ping.  Peter, Ingo?

Thanks for your ping, even i was thinking of it since sometime :)

> Viresh, would it be difficult to make another measurement of the same
> workload with the said workqueues converted to unbound?  I think that
> would at least provide a nice reference point.

I will try.
