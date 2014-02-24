Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaBXHNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:13:31 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:33843 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaBXHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:13:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140224070731.GV9987@twins.programming.kicks-ass.net>
References: <tip-vmme4f49psirp966pklm5l9j@git.kernel.org>
	<CALZhoSRZT+T-DxJP2QD0na58bsjf7t89_v0+iMxZZMcc_r1cBQ@mail.gmail.com>
	<20140224070731.GV9987@twins.programming.kicks-ass.net>
Date: Mon, 24 Feb 2014 15:13:29 +0800
Message-ID: <CALZhoSRaPnOo_R+MKK6O6xn+hTyMyYOU25b_1kwLvaijvMoOiw@mail.gmail.com>
Subject: Re: [tip:sched/core] sched, nohz: Exclude isolated cores from load balancing
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, leiwen@marvell.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 3:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Feb 24, 2014 at 10:11:05AM +0800, Lei Wen wrote:
>> How about use the API as cpumask_test_and_clear_cpu?
>> Then below one line is enough.
>
> Its more expensive.
>

I see...
No problem for me then.

Acked-by: Lei Wen <leiwen@marvell.com>

Thanks,
Lei
