Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3HWNB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:01:29 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:51222 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3HWNB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:01:28 -0400
Message-ID: <52175D45.4010506@fold.natur.cuni.cz>
Date: Fri, 23 Aug 2013 15:01:57 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Peter Zijlstra <peterz@infradead.org>
CC: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [sched_delayed] sched: RT throttling activated
References: <521722EE.70209@fold.natur.cuni.cz> <20130823100913.GQ31370@twins.programming.kicks-ass.net> <52173BBD.3050803@fold.natur.cuni.cz> <20130823110254.GU31370@twins.programming.kicks-ass.net> <521748FC.10809@fold.natur.cuni.cz> <20130823121004.GW31370@twins.programming.kicks-ass.net> <5217599C.3080707@fold.natur.cuni.cz>
In-Reply-To: <5217599C.3080707@fold.natur.cuni.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Martin Mokrejs wrote:

>>>> Nope, you get that message once to tell you that we throttle RT tasks.
>>>
>>> I think the message could improved to explain this is a warn ONCE message and
>>> that there is no "[sched_delayed] sched: RT throttling deactivated" counterpart
>>> message to be anticipated.
>>
>> Would something like: 
>>
>>   sched: [ONCE] RT throttle hit -- inspect system configuration.
>>
>> Be a better message?
> 
> Not really. I would prefer something like:
> 
> [sched_delayed] sched: stopped running $cmd on CPU%d in favor of RR/FIFO task $psname

Actually, to retain the message text appearing in current kernel so that people can find
by e.g. Google newer syntax and possibly this thread maybe much better would be:

[sched_delayed] sched: RT throttling limit $d hit. Stopped running $cmd on CPU%d in favor of RR/FIFO task $psname. Will not issue any more these messages until reboot.

I know, looong line.


I just realized this is about some threshold limit value, and you mean that iwlwifi
contributed the highest increase compared to the other kernel threads on my system.

sysctl -q -a |  grep -i limit

does not show what is the actual value. Am probably looking into a wrong place. ;-)

