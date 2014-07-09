Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaGIKbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:31:12 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37426 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaGIKbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:31:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140709101413.GR19379@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org> <20140709101413.GR19379@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 9 Jul 2014 12:30:49 +0200
Message-ID: <CAKfTPtAfYxxy1jg_DhdBvQzMKso2qw=8n2BktjvjQs5OAisobQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] sched: fix imbalance flag reset
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 12:14, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 06:05:32PM +0200, Vincent Guittot wrote:
>> +++ b/kernel/sched/fair.c
>> @@ -6615,10 +6615,8 @@ more_balance:
>
> In order to avoid labels being used as functions; you can use:
>
> .quiltrc:
> QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"
>
> .gitconfig:
> [diff "default"]
>         xfuncname = "^[[:alpha:]$_].*[^:]$"
>

Thanks, i'm going to add it to my .gitconfig

>
