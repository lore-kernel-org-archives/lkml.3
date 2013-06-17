Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab3FQMZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:25:53 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:47823 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab3FQMZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:25:52 -0400
MIME-Version: 1.0
In-Reply-To: <1370590169-24804-3-git-send-email-alex.shi@intel.com>
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <1370590169-24804-3-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 05:25:19 -0700
Message-ID: <CAPM31R+Rmmn471ZE97q3DhAgZiu3s2fEoqf7unO6sB6=H8w37A@mail.gmail.com>
Subject: Re: [RFC patch 2/4] sched/tg: use 'unsigned long' for load variable
 in task group
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 12:29 AM, Alex Shi <alex.shi@intel.com> wrote:
> Since tg->load_avg is smaller than tg->load_weight, we don't need a
> atomic64_t variable for load_avg in 32 bit machine.
> The same reason for cfs_rq->tg_load_contrib.

This description is incorrect, another patch removes tg->load_weight
for being unused.

Rest seems fine.
