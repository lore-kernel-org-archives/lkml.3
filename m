Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab3FQMXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:23:01 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:45142 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3FQMW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:22:58 -0400
MIME-Version: 1.0
In-Reply-To: <1370590169-24804-5-git-send-email-alex.shi@intel.com>
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <1370590169-24804-5-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 05:22:26 -0700
Message-ID: <CAPM31RLm8LopE1auM0diiycoArfChJf=dvgeCP0sT3EaHAwtOQ@mail.gmail.com>
Subject: Re: [RFC patch 4/4] sched/tg: remove tg.load_weight
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
> Since no one use it.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Reviewed-by: Paul Turner <pjt@google.com>
