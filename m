Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbaGWJbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:31:36 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:49953 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751347AbaGWJbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:31:34 -0400
Message-ID: <53CF80EE.5050702@daenzer.net>
Date: Wed, 23 Jul 2014 18:31:26 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
References: <53C77BB8.6030804@daenzer.net> <20140717075820.GE19379@twins.programming.kicks-ass.net> <53C8E90F.1010306@daenzer.net> <53CE00EF.70108@daenzer.net> <53CF31AE.30403@daenzer.net> <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com> <20140723064948.GK3935@laptop> <53CF6CC4.6090207@daenzer.net> <20140723082819.GR3935@laptop> <20140723092536.GO12054@laptop.lan>
In-Reply-To: <20140723092536.GO12054@laptop.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2014 18:25, Peter Zijlstra wrote:
> On Wed, Jul 23, 2014 at 10:28:19AM +0200, Peter Zijlstra wrote:
> 
>> Of course, the other thing that patch did is clear sgp->power (now
>> sgc->capacity). 
> 
> Hmm, re-reading the thread there isn't a clear confirmation its this
> patch at all. Could you perhaps bisect this to either verify it is
> indeed that patch we're talking about:
> 
> caffcdd8d27b ("sched: Do not zero sg->cpumask and sg->sgp->power in build_sched_groups()")
> 
> or find which patch is causing this.

It can take a long time for the problem to occur, so I need to run at
least for one or two days to be at least somewhat sure a given kernel is
not affected.

I'll try reproducing the problem with your previous suggestions first,
but if I manage to do that, I guess there's no alternative to bisecting...


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
