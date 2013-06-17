Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab3FQM0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:26:43 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:57589 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab3FQM0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <1370589652-24549-3-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-3-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 05:26:10 -0700
Message-ID: <CAPM31RLzTyi5vsW-3Fx-CA4i6oneoh588VRBBhvzkKSeDJjP0g@mail.gmail.com>
Subject: Re: [patch v8 2/9] sched: move few runnable tg variables into CONFIG_SMP
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
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
> The following 2 variables only used under CONFIG_SMP, so better to move
> their definiation into CONFIG_SMP too.
>
>         atomic64_t load_avg;
>         atomic_t runnable_avg;
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Looks fine; the manipulations to the structs could perhaps be
collapsed to one patch.
