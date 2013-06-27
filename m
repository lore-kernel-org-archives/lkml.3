Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3F0KXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:23:04 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:39539 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3F0KXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130626103653.GC28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<1371824448-7306-3-git-send-email-eranian@google.com>
	<20130624084510.GK28407@twins.programming.kicks-ass.net>
	<CABPqkBQRchnjhnEC05w-noizoeSRnNio7NDQ6_+vXym_7rkGaw@mail.gmail.com>
	<20130626103653.GC28407@twins.programming.kicks-ass.net>
Date: Thu, 27 Jun 2013 12:23:00 +0200
Message-ID: <CABPqkBQuYy3TeE81tTXVruMG4D84TQ2U5g69T2ResGgjPjK4Cg@mail.gmail.com>
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

Peter,

I don't this see patch in tip.git yet.

On Wed, Jun 26, 2013 at 12:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jun 26, 2013 at 09:36:39AM +0200, Stephane Eranian wrote:
>> On Mon, Jun 24, 2013 at 10:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, Jun 21, 2013 at 04:20:42PM +0200, Stephane Eranian wrote:
>> >> Now that we use the contraints directly from the event, we
>> >> do not need the event->flags field so drop it.
>> >>
>> >> Signed-off-by: Stephane Eranian <eranian@google.com>
>> >
>> > Same for this one I suppose; its not really related to the series at
>> > hand.
>>
>> Correct. I can submit separately if needed.
>
> I applied the first patch; this one failed to apply.. Remind me again if
> I fail to remember looking at the rejects once I've collected all other
> patches I planned to ship to mingo today.
