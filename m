Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaDNDca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 23:32:30 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:47503 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaDNDc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 23:32:29 -0400
MIME-Version: 1.0
In-Reply-To: <1397445480.5243.6.camel@joe-AO722>
References: <CAJhHMCCE0QHvzqrdY-w8bB8ZK=JRN02V29XwaFYRXmu=9RhG9Q@mail.gmail.com>
 <CAJhHMCCgMgL2etE8sYPgUfy+OXcyxG6_X1v1OhUxzX5c0kaZ4w@mail.gmail.com>
 <1397443846.5243.2.camel@joe-AO722> <CAJhHMCBsa6ypbaLZ2Uv6x60uU-xq=veAem85Ke=-R+nbW5=5fA@mail.gmail.com>
 <1397445480.5243.6.camel@joe-AO722>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 13 Apr 2014 23:31:57 -0400
Message-ID: <CAJhHMCBihYJYJv1OKP1ZrgT5tVA801_opVKmhkpAtYhRP7Rs_w@mail.gmail.com>
Subject: Re: [PATCH 1/1] kernel/rcu/tree.c: remove duplicate extern definition
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 11:18 PM, Joe Perches <joe@perches.com> wrote:

>> As the comment mentions, resched_cpu is internal to the scheduler and
>> hence is in sched/sched.h file and not in linux/sched.h.
>
> Note the use of quotes and lack of angle brackets.
>
>> sched/sched.h cannot be included in other subsystems directly.
>
> If functions from it can be declared extern,
> then likely it could be used in an #include.
>
>

All the users of resched_cpu are in kernel/sched/ and in
kernel/rcu/tree.c. I think the only reason this was declared extern
was for the special use in rcu/tree.c.


-- 
Pranith
