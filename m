Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422649Ab3LTNv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:51:26 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:50661 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab3LTNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:51:23 -0500
Message-ID: <52B44B56.1020903@gmail.com>
Date: Fri, 20 Dec 2013 14:51:18 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH 00/13] sched, deadline: patches
References: <20131217122720.950475833@infradead.org>
In-Reply-To: <20131217122720.950475833@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/17/2013 01:27 PM, Peter Zijlstra wrote:
> Hai..
> 
> This is my current queue of SCHED_DEADLINE; which I hope to merge 'soon'.
> 
> Juri handed me a version that should've (didn't check) included all feedback
> including the new sched_attr interface.
> 
> I did clean up some of the patches; moved some hunks around so that each patch
> compiles on its own etc..
> 
> I then did a number of patches at the end to change some actual stuff around.
> 
> Juri do you have some userspace around to test with? I'm just too likely to
> have wrecked everything; so if you don't have something I need to go write
> something before merging this :-)
> 
> No need to update your test proglets to the new interface, I can lift it if
> that is more convenient -- I know you're conferencing atm.
> 

I use this: https://github.com/gbagnoli/rt-app/tree/new-ABI
It is aligned with the new ABI (but it is missing your last changes).

> One question; the SoB chain in patch 2/13 seems weird; I suppose that
> patch is a collaborative effort? could we cure that by mentioning Fabio
> and Michael in some other way?
> 

We could change their SoB to be a Cc (not sure this cure the thing anyway). Not
even Cc-ing them seems pointless. Then we have them mentioned in
sched/deadline.c copyright (oh! s/2012/2014/ there :-O).

Thanks,

- Juri
