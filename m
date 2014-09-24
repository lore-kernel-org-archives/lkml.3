Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaIXIb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:31:58 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36175 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaIXIbz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:31:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140924074927.GS16043@twins.programming.kicks-ass.net>
References: <1411484269-32311-1-git-send-email-eranian@google.com>
	<20140924074927.GS16043@twins.programming.kicks-ass.net>
Date: Wed, 24 Sep 2014 10:31:55 +0200
Message-ID: <CABPqkBTphY=jhec6vUJHXtmODuHbOqYm_kkz0O7yKNHt08NYiA@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] perf: add ability to sample interrupted machine state
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 9:49 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Sep 23, 2014 at 04:57:43PM +0200, Stephane Eranian wrote:
>> In V6, we added the missing copy of the eflags from the PEBS
>> mahcine state (reported by Andi). We fixed some formatting
>> issues. We rebased to 3.17-rc6.
>
> ../arch/x86/kernel/cpu/perf_event_intel_ds.c: In function ‘__intel_pmu_pebs_event’:
> ../arch/x86/kernel/cpu/perf_event_intel_ds.c:899:7: error: ‘struct pt_regs’ has no member named ‘eflags’
>
> You mean that?
>
Is that compiling v6?
I thought I had fixed that.
Needs to be flags not eflags.
I can repost for V7.
Sorry about that.
