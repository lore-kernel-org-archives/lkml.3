Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3EUNqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:46:44 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33139 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3EUNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130521085010.GB26912@twins.programming.kicks-ass.net>
References: <20130503121122.931661809@chello.nl>
	<20130503121256.230745028@chello.nl>
	<CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com>
	<20130516090916.GF19669@dyad.programming.kicks-ass.net>
	<8578.1368699317@ale.ozlabs.ibm.com>
	<20130516111634.GA15314@twins.programming.kicks-ass.net>
	<CABPqkBSCXJN7gLK_e_Q3YVVVFVGS78fo4j2z0+MmriqoXszH+w@mail.gmail.com>
	<20130517111232.GE5162@dyad.programming.kicks-ass.net>
	<10224.1369114895@ale.ozlabs.ibm.com>
	<20130521085010.GB26912@twins.programming.kicks-ass.net>
Date: Tue, 21 May 2013 15:46:42 +0200
Message-ID: <CABPqkBTX9HkeoQ3YAduG8C=Vyy=74Av2ZORMKAo6T9aERmR93w@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, May 21, 2013 at 03:41:35PM +1000, Michael Neuling wrote:
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> Can we add your signed-off-by on this?
>>
>> We are cleaning up our series for conditional branches and would like to
>> add this as part of the post.
>
> Sure, but its completely untested.. I was hoping Stephane would say
> somnething about it since he wrote all that magic ;-)
>
Let me take a look at it.

> But yeah, feel free to add my SoB.
