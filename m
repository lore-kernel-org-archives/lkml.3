Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaFXMfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:35:09 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:65409 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaFXMfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:35:06 -0400
MIME-Version: 1.0
In-Reply-To: <1403612280.29711.115.camel@marge.simpson.net>
References: <0dfbe2976aa108c53e08d3477ea90f6360c1f54c.1403584026.git.viresh.kumar@linaro.org>
	<20140624080347.GL13930@laptop.programming.kicks-ass.net>
	<1403612280.29711.115.camel@marge.simpson.net>
Date: Tue, 24 Jun 2014 18:05:04 +0530
Message-ID: <CAKohponybcMZ36EM+FQTNU3_WVHoKC+PWDpnd_4qKSzqrPb2=g@mail.gmail.com>
Subject: Re: [PATCH] sched/idle: Drop !! while calculating 'broadcast'
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2014 17:48, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> x86_64 gcc-4.8.3 made 1 less instruction, a shift.

I thought about doing this test for x86 as well, and over-estimated
compilers intelligence. I must have done it :)

And finally this patch is worth more than I originally estimated :)
