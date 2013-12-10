Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3LJBGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:06:55 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:38784 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3LJBGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <52A668B8.5090709@linaro.org>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
 <20131203102650.GA8070@laptop.programming.kicks-ass.net> <52A668B8.5090709@linaro.org>
From: Paul Turner <pjt@google.com>
Date: Mon, 9 Dec 2013 17:06:21 -0800
Message-ID: <CAPM31R+H-==kDyBd6YRXshm23iabWb+oieAUWrZOx2phZEJEOw@mail.gmail.com>
Subject: Re: [PATCH 0/4] sched: remove cpu_load decay
To: Alex Shi <alex.shi@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        linux@arm.linux.org.uk, "tony.luck@intel.com" <tony.luck@intel.com>,
        fenghua.yu@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, james.hogan@imgtec.com,
        Jason Low <jason.low2@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hanjun.guo@linaro.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 5:04 PM, Alex Shi <alex.shi@linaro.org> wrote:
> On 12/03/2013 06:26 PM, Peter Zijlstra wrote:
>>
>> Paul, can you guys have a look at this, last time around you have a
>> regression with this stuff, so it would be good to hear from you.
>>
>
> Ping Paul.
>

Ben was looking at this right before the thanksgiving break.  I'll ask
him what he has tomorrow.

> --
> Thanks
>     Alex
