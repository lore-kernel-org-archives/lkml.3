Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3FZHgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:36:41 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54299 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3FZHgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130624084510.GK28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<1371824448-7306-3-git-send-email-eranian@google.com>
	<20130624084510.GK28407@twins.programming.kicks-ass.net>
Date: Wed, 26 Jun 2013 09:36:39 +0200
Message-ID: <CABPqkBQRchnjhnEC05w-noizoeSRnNio7NDQ6_+vXym_7rkGaw@mail.gmail.com>
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

On Mon, Jun 24, 2013 at 10:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jun 21, 2013 at 04:20:42PM +0200, Stephane Eranian wrote:
>> Now that we use the contraints directly from the event, we
>> do not need the event->flags field so drop it.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Same for this one I suppose; its not really related to the series at
> hand.

Correct. I can submit separately if needed.
