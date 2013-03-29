Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3C2R4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:56:54 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:64775 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3C2R4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:56:52 -0400
Date: Fri, 29 Mar 2013 10:56:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
Message-ID: <20130329175645.GB9862@htj.dyndns.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
 <fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
 <20130321001211.GC31256@htj.dyndns.org>
 <CAKohponKUGbwEZ_edu353Y7YVZKgFOhZunTSUi04FGYWveftkw@mail.gmail.com>
 <20130321182937.GB20500@htj.dyndns.org>
 <20130328181332.GD14088@htj.dyndns.org>
 <CAKohpomkGxUy6-7tByBjQvAGSUn4EdVCpGo+94fn7vF8YgKRLQ@mail.gmail.com>
 <20130329174003.GA9862@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329174003.GA9862@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 10:40:03AM -0700, Tejun Heo wrote:
> So the scheduler does know what it's doing after all, which is a nice
> news.  Given the result, the best thing to do would be somehow marking
> these workqueues as unbound for powersaving?

BTW, recent changes to workqueue means that it shouldn't be too
difficult to create a combined workqueue which distributes work items
to both per-cpu and unbound worker pools depending on cpu_idle(), but,
at least for now, I think we can make do with much coarser approach.
We can refine it afterwards.

Thanks.

-- 
tejun
