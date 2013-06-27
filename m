Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3F0LBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:01:05 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63377 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3F0LBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:01:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130627104833.GC27378@dyad.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<1371824448-7306-3-git-send-email-eranian@google.com>
	<20130624084510.GK28407@twins.programming.kicks-ass.net>
	<CABPqkBQRchnjhnEC05w-noizoeSRnNio7NDQ6_+vXym_7rkGaw@mail.gmail.com>
	<20130626103653.GC28407@twins.programming.kicks-ass.net>
	<CABPqkBQuYy3TeE81tTXVruMG4D84TQ2U5g69T2ResGgjPjK4Cg@mail.gmail.com>
	<20130627104833.GC27378@dyad.programming.kicks-ass.net>
Date: Thu, 27 Jun 2013 13:01:02 +0200
Message-ID: <CABPqkBSwrz_GSobSuXn+AvU1zp14nAccCer4o7DHmG2c90cxRA@mail.gmail.com>
Subject: Re: [PATCH 2/8] perf,x86: drop event->flags and use hw.constraint->flags
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jun 27, 2013 at 12:23:00PM +0200, Stephane Eranian wrote:
>> Peter,
>>
>> I don't this see patch in tip.git yet.
>
> Didn't apply and I didn't get around to beating it into shape; could you resend
> against tip/master. Ingo just pushed out all the other bits.

Ok, the chunks that do not apply can be ignored for perf_event_intel.c.
They were already included in my offcore-response sched fix patch.
But I can repost if you prefer.
