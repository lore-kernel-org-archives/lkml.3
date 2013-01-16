Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3APO6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:58:08 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:52706 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3APO6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:58:07 -0500
MIME-Version: 1.0
In-Reply-To: <87wqvdl1n8.fsf@sejong.aot.lge.com>
References: <1358339577-28766-1-git-send-email-fweisbec@gmail.com>
	<87wqvdl1n8.fsf@sejong.aot.lge.com>
Date: Wed, 16 Jan 2013 15:58:05 +0100
Message-ID: <CAFTL4hzkvYj=B5TS4p_k=mjLTBWCoZmOQ5G0JCqtU5xVZ8WCxQ@mail.gmail.com>
Subject: Re: [PATCH] context_tracking: Add comments on interface and internals
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/16 Namhyung Kim <namhyung@kernel.org>:
> Hi Frederic,
>
> On Wed, 16 Jan 2013 13:32:57 +0100, Frederic Weisbecker wrote:
>> This subsystem lacks many explanations on its purpose and
>> design. Add these missing comments.
>>
>> v3: Fix the "hook" based naming as per Ingo's suggestion
> [snip]
>> +/**
>> + * context_tracking_task_switch - context switch the syscall callbacks
>
> To be more kernel-doc-friendly, it'd better adding descriptions for
> arguments too:
>
>  @prev: the task that is being switched out
>  @next: the task we are going to switch to

Right, I'm fixing that.

Thanks.
