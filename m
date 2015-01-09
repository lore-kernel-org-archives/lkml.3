Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbbAITYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:24:12 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:49661 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbAITYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:24:10 -0500
MIME-Version: 1.0
In-Reply-To: <1420773280.5340.16.camel@marge.simpson.net>
References: <CAH86sKKCbZ7CYDEgAnpiVH+7TZNOjziUYOJSWHEpQyY3eUSniA@mail.gmail.com>
	<1420694794.5279.33.camel@marge.simpson.net>
	<CAH86sKJJWACmjC0VfF4AHEvsLQ42T81JOYseykzrEB=tVfZQDA@mail.gmail.com>
	<1420773280.5340.16.camel@marge.simpson.net>
Date: Fri, 9 Jan 2015 11:24:10 -0800
Message-ID: <CAH86sKJnx1wgtkZ-S0QHcRf4dXvSsVoB4U66Yf2vLpruuNeYNA@mail.gmail.com>
Subject: Re: sched_yield() call on Linux Kernel 2.6.39 is not behaving correct
From: Yogesh Ahire <yogesh02061983@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Mike. I didn't get what you mean by saying "its gona try to
yield for one hell of a long time before it succeeds".

On Thu, Jan 8, 2015 at 7:14 PM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> On Thu, 2015-01-08 at 10:00 -0500, Yogesh Ahire wrote:
>> Thank you Mike. But I can see there are tasks with same priority and
>> are runnable waiting for CPU, following is the output of
>> /proc/sched_debug where you can see that the task "symphonyapp"
>> continuously calls sched_yield() but there are other tasks which are
>> ready to run are not getting CPU and are queued back.
>
> Something terminally bad happened.  With that tasks vruntime (tree-key),
> it's gonna try to yield for one hell of a long time before it succeeds.
>
> -Mike
>
