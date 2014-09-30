Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaI3Jio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:38:44 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:43537 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaI3Jim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org>
References: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 30 Sep 2014 11:38:21 +0200
Message-ID: <CAKfTPtAfyHL_aq8cEdeOzvRh_OaBFuv1_5uqTQG9soh=AR1zqA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix spurious active migration
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 September 2014 10:41, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> Since commit caeb178c60f4 ("sched/fair: Make update_sd_pick_busiest() ...")

As someone asked me on IRC, I want to clarify that this commit is not
yet in mainline but in tip/sched/core branch

> sd_pick_busiest returns a group that can be neither imbalanced nor overloaded
> but is only more loaded than others. This change has been introduced to ensure
> a better load balance in system that are not overloaded but as a side effect,
> it can also generate useless active migration between groups.
>

[snip]
