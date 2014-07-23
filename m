Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbaGWJps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:45:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55670 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbaGWJpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:45:46 -0400
Message-ID: <53CF844A.5050106@arm.com>
Date: Wed, 23 Jul 2014 10:45:46 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
References: <53C77BB8.6030804@daenzer.net> <20140717075820.GE19379@twins.programming.kicks-ass.net> <53C8E90F.1010306@daenzer.net> <53CE00EF.70108@daenzer.net> <53CF31AE.30403@daenzer.net> <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com> <20140723064948.GK3935@laptop> <53CF6CC4.6090207@daenzer.net> <20140723082819.GR3935@laptop> <20140723092536.GO12054@laptop.lan> <53CF80EE.5050702@daenzer.net>
In-Reply-To: <53CF80EE.5050702@daenzer.net>
X-OriginalArrivalTime: 23 Jul 2014 09:45:43.0742 (UTC) FILETIME=[DF1B75E0:01CFA65A]
X-MC-Unique: 114072310454406501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/14 10:31, Michel Dänzer wrote:
> On 23.07.2014 18:25, Peter Zijlstra wrote:
>> On Wed, Jul 23, 2014 at 10:28:19AM +0200, Peter Zijlstra wrote:
>>
>>> Of course, the other thing that patch did is clear sgp->power (now
>>> sgc->capacity). 
>>
>> Hmm, re-reading the thread there isn't a clear confirmation its this
>> patch at all. Could you perhaps bisect this to either verify it is
>> indeed that patch we're talking about:
>>
>> caffcdd8d27b ("sched: Do not zero sg->cpumask and sg->sgp->power in build_sched_groups()")
>>
>> or find which patch is causing this.
> 
> It can take a long time for the problem to occur, so I need to run at
> least for one or two days to be at least somewhat sure a given kernel is
> not affected.

Doesn't the picture showing the captured panic reveal more information.
Haven't seen it myself, I just saw Peter's reply to your email

https://lkml.org/lkml/2014/7/17/100

> 
> I'll try reproducing the problem with your previous suggestions first,
> but if I manage to do that, I guess there's no alternative to bisecting...
> 
> 


