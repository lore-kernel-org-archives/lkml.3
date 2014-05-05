Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaEEUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:16:56 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62576 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaEEUQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:16:55 -0400
Message-ID: <5367F1B4.2010704@linaro.org>
Date: Mon, 05 May 2014 13:16:52 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/4] printk: Re-add irqsave/restore in printk_sched
References: <1399068558-2373-1-git-send-email-john.stultz@linaro.org> <1399068558-2373-2-git-send-email-john.stultz@linaro.org> <20140504145847.GA7433@quack.suse.cz> <20140504161312.GL17778@laptop.programming.kicks-ass.net>
In-Reply-To: <20140504161312.GL17778@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 09:13 AM, Peter Zijlstra wrote:
> On Sun, May 04, 2014 at 04:58:47PM +0200, Jan Kara wrote:
>> On Fri 02-05-14 15:09:15, John Stultz wrote:
>>> A commit in akpm's tree (printk: remove separate printk_sched
>>> buffers...), removed the printk_sched irqsave/restore lines
>>> since it was safe for current users. Since we may be expanding
>>> usage of printk_sched(), re-add the irqsave/restore logic
>>> to make the functionality more generally safe.
>>   So I'm just wondering: Do you have anything particular for which you need
>> interrupts disabled? Won't e.g. disabling preemption be enough?
> Yeah, I think preemption disabled is sufficient.

Ok, will change this and resend.

thanks
-john
