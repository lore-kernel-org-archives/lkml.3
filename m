Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3KRPSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:18:41 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53583 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3KRPSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:18:35 -0500
MIME-Version: 1.0
In-Reply-To: <20131118085439.GD3866@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu>
	<20131115145944.GA3694@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1311151223040.11932@vincent-weaver-1.um.maine.edu>
	<20131118085439.GD3866@twins.programming.kicks-ass.net>
Date: Mon, 18 Nov 2013 16:18:34 +0100
Message-ID: <CABPqkBRe0xK_mf4JE+0e-UDs92Os_3dreHfh-wnG78fquTCRHQ@mail.gmail.com>
Subject: Re: perf sw_event related lockup
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I missed the beginning of this thread somehow.
What's the initial problem?


On Mon, Nov 18, 2013 at 9:54 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Nov 15, 2013 at 12:26:16PM -0500, Vince Weaver wrote:
>> On Fri, 15 Nov 2013, Peter Zijlstra wrote:
>> >
>> > Please enable CONFIG_FRAME_POINTER to get better backtraces, but the
>> > above suggests the pagefault swevent, will have a look.
>>
>> here it is again I think.  I compiled with CONFIG_FRAME_POINTER but the
>> backtraces don't look that different.
>
> Looks to be that other one -- the one where the intel constraints thing
> goes belly up. I was hoping Stephane would look at that since I know
> he's been rewriting that code.
