Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab3HMOB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:01:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11699 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab3HMOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:01:46 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=RbvQYlb-YjEA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=aGOhDPDwV-YA:10 a=20KFwNOVAAAA:8 a=69EAbJreAAAA:8 a=tB4JYbadIHrABSbNQcoA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=EfJqPEOeqlMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 10:01:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] tracing: final fixes for events and some
Message-ID: <20130813100143.0f09fae2@gandalf.local.home>
In-Reply-To: <20130813114503.GA31585@redhat.com>
References: <1375712355.22073.45.camel@gandalf.local.home>
	<20130805143257.GA32639@gmail.com>
	<1375714329.22073.63.camel@gandalf.local.home>
	<20130812181325.GA19405@gmail.com>
	<20130813023922.GA1042@redhat.com>
	<20130812231443.52563398@gandalf.local.home>
	<20130813110618.GA3300@gmail.com>
	<20130813114503.GA31585@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 07:45:03 -0400
Dave Jones <davej@redhat.com> wrote:


> But the recent fix where you had a test-case that did module unloads
> didn't really seem to fit the profile of what I was seeing.
> It's feasible that my fuzzer can trigger module _loads_, but I
> don't think there's any way we can trigger an rmmod.

I don't know your tool well enough, so I don't know what its capable of.

The only reproducer that I had was on module loading. I don't know of
any other way that could have corrupted the function tracing tables.
But there may be another way. We'll have to wait till it happens again
and hopefully next time we'll have more information to what exactly
happened. 

-- Steve
