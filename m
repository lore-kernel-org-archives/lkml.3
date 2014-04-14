Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaDNDDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 23:03:52 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:57345 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDNDDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 23:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <1397443846.5243.2.camel@joe-AO722>
References: <CAJhHMCCE0QHvzqrdY-w8bB8ZK=JRN02V29XwaFYRXmu=9RhG9Q@mail.gmail.com>
 <CAJhHMCCgMgL2etE8sYPgUfy+OXcyxG6_X1v1OhUxzX5c0kaZ4w@mail.gmail.com> <1397443846.5243.2.camel@joe-AO722>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 13 Apr 2014 23:03:19 -0400
Message-ID: <CAJhHMCBsa6ypbaLZ2Uv6x60uU-xq=veAem85Ke=-R+nbW5=5fA@mail.gmail.com>
Subject: Re: [PATCH 1/1] kernel/rcu/tree.c: remove duplicate extern definition
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 10:50 PM, Joe Perches <joe@perches.com> wrote:
>>
>> -/*
>> - * This function really isn't for public consumption, but RCU is special in
>> - * that context switches can allow the state machine to make progress.
>> - */
>> -extern void resched_cpu(int cpu);
>
> why not #include "sched.h"
>
> and remove both declarations?
>
>

As the comment mentions, resched_cpu is internal to the scheduler and
hence is in sched/sched.h file and not in linux/sched.h.

sched/sched.h cannot be included in other subsystems directly.

Regards,
-- 
Pranith
