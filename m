Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3JOJGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:06:25 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:39279 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3JOJGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:06:23 -0400
Message-ID: <525D058C.1020104@gmail.com>
Date: Tue, 15 Oct 2013 11:06:20 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 07/14] sched: add schedstats for -deadline tasks.
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-8-git-send-email-juri.lelli@gmail.com> <20131014120831.GJ3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014120831.GJ3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 02:08 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:39PM +0200, Juri Lelli wrote:
>> From: Dario Faggioli <raistlin@linux.it>
>>
>> Add some typical sched-debug output to dl_rq(s) and some
>> schedstats to -deadline tasks.
> 
> Could you perhaps add a bit to the changelog explaining what kind of
> problems this patch helped (or could help) to find?
> 

Expanded in this:

Add some typical sched-debug output to dl_rq(s) and some
schedstats to -deadline tasks. This helps spotting problems
with queue and dequeue operations (incorrect ordering) and
gives hints about system status (one can have an idea if the
system is overloaded, if tasks are missing their deadlines
and the entity of such anomalies).

Thanks,

- Juri
