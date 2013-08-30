Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3H3OPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:15:47 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37156 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3H3OPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130830140841.GS31370@twins.programming.kicks-ass.net>
References: <1377079825-19057-1-git-send-email-eranian@google.com>
	<1377079825-19057-3-git-send-email-eranian@google.com>
	<20130822105109.GI31370@twins.programming.kicks-ass.net>
	<CABPqkBQUqNX4W8UVzbJ6sB=JVbMY=ZJgYbRLRHX3DnvCz6SOsw@mail.gmail.com>
	<20130830140841.GS31370@twins.programming.kicks-ass.net>
Date: Fri, 30 Aug 2013 16:15:45 +0200
Message-ID: <CABPqkBRnBsw6eMbWbe3tgOo8BQyiORjvtATw33+jAvXB7LRQOg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 4:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Aug 30, 2013 at 04:03:26PM +0200, Stephane Eranian wrote:
>> Hi,
>>
>> I realized I have forgotten to patch builtin-inject.c to repipe mmap2 records.
>> Will resubmit V3.
>
> OK, I already queued the previous two, it looked fine and the ack was
> long in coming. If mingo manages to push out before I can pick up v3
> I'll frob a delta patch.

I can submit a separate patch to cover for builtin-inject.c
