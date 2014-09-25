Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaIYQWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:22:21 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:48182 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:22:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140925142929.GD4140@worktop.programming.kicks-ass.net>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
	<20140925092629.GC4140@worktop.programming.kicks-ass.net>
	<CABPqkBTwjkRbc8BBYWOkGAOsSsiVwsrSENqybSb260vsW9hcJg@mail.gmail.com>
	<20140925142929.GD4140@worktop.programming.kicks-ass.net>
Date: Thu, 25 Sep 2014 18:22:19 +0200
Message-ID: <CABPqkBS-iOCYhPgJH-G8ryAwmt2EF5Mo7n4T0Oncztc5qTePOQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] perf: add ability to sample interrupted machine state
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 4:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Sep 25, 2014 at 12:32:39PM +0200, Stephane Eranian wrote:
>> Peter,
>>
>> On Thu, Sep 25, 2014 at 11:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> >
>> > These do indeed appear to compile just fine, thanks!
>> >
>> I posted v7 with the x86_32 fixes and the eflags changes.
>> Is that what you compiled?
>
> Yep, I grabbed the latest. I've not yet tried the x86_32 compile, but I
> did check the 'offending' patch and it has the #ifdef guard in place so
> I'll assume it works for now.

Yes, I compiled on my 32-bit Atom laptop. It compiles.
