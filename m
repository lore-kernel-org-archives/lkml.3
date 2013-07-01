Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3GAPHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:07:34 -0400
Received: from mail-gh0-f182.google.com ([209.85.160.182]:53864 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3GAPHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:07:31 -0400
Date: Mon, 1 Jul 2013 11:13:01 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: [testcase] perf: yet another fuzzer triggered crash
In-Reply-To: <20130701090713.GO6626@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Peter Zijlstra wrote:


> OK, so on my westmere it triggers that WARN in task_ctx_sched_out() a
> _lot_ (I removed the ONCE for easier debugging earlier -- still kinda
> stumped there).
> 
> Then this thing causes an RCU stall and starts triggering NMI watchdog
> msgs.. so YAY! :-)

I'm glad it's not just me.

I'm in the process of kernel bisecting this, though all I can tell you so 
far is 2.6.32 is unaffected by the bug but 3.2 and later are.

Vince
