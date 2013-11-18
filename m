Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3KRQgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 11:36:06 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:57638 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3KRQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 11:35:58 -0500
Date: Mon, 18 Nov 2013 11:44:25 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Stephane Eranian <eranian@google.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf sw_event related lockup
In-Reply-To: <CABPqkBQqa_foaozcHkHBU+VFTcVKrkgVcidUQNzWayB53yBa8g@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1311181142380.18020@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu> <20131115145944.GA3694@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1311151223040.11932@vincent-weaver-1.um.maine.edu> <20131118085439.GD3866@twins.programming.kicks-ass.net>
 <CABPqkBRe0xK_mf4JE+0e-UDs92Os_3dreHfh-wnG78fquTCRHQ@mail.gmail.com> <20131118153219.GH3866@twins.programming.kicks-ass.net> <CABPqkBQqa_foaozcHkHBU+VFTcVKrkgVcidUQNzWayB53yBa8g@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Stephane Eranian wrote:

> What's the config for this test?
> Need to host CPU type and the event config.
> Otherwise there is not much I can do with the crash dump.

It's 3.12, on a core2 machine.

Sadly I don't have the event config.  To reproduce I start my perf_fuzzer 
running and typically it will hit the error/lockup within an hour or so 
of fuzzing assuming it doesn't hit one of the other outstanding bugs 
first.

I can probably narrow it down but that involves a lot of luck as well as a 
lot of time and I might not get a chance to do so until next month at the 
earliest.

Vince
