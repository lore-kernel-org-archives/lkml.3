Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaBYDhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:37:33 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:54976 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaBYDhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:37:31 -0500
Message-ID: <530C0FDF.4000506@hp.com>
Date: Mon, 24 Feb 2014 22:37:03 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <53029167.4060109@zytor.com> <20140218073825.GY27965@twins.programming.kicks-ass.net> <20140222165613.GA30098@gmail.com>
In-Reply-To: <20140222165613.GA30098@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 11:56 AM, Ingo Molnar wrote:
> * Peter Zijlstra<peterz@infradead.org>  wrote:
>
>> On Mon, Feb 17, 2014 at 02:47:03PM -0800, H. Peter Anvin wrote:
>>> This is starting to look good, so I have pulled it into
>>> tip:x86/spinlocks to start give it some testing mileage.
>> Its still atrociously ugly code please drop it.
> Fair enough - I've excluded it from tip:master for now, until the
> uglies get resolved.
>
> Waiman: please address PeterZ's feedback.
>
> Thanks,
>
> 	Ingo

I am trying to address PeterZ's feedback while adding 
para-virtualization support right now. I will have a new version ready 
sometime this week.

-Longman
