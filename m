Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab3BLRdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:33:45 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:39612 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3BLRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:33:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130212172951.GD30387@tassilo.jf.intel.com>
References: <1360678168-6974-1-git-send-email-eranian@google.com>
	<20130212172319.GB30387@tassilo.jf.intel.com>
	<CABPqkBTZ+ooWHFvagR=YFDUdnnW9az0LXg1-etNfgC2Af8yA-w@mail.gmail.com>
	<20130212172951.GD30387@tassilo.jf.intel.com>
Date: Tue, 12 Feb 2013 18:33:42 +0100
Message-ID: <CABPqkBQBnN8y7WWWye1e0goJ6On1SYOKWsUG9=R76+d7ScWLDg@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf stat: add per-core count aggregation
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 6:29 PM, Andi Kleen <ak@linux.intel.com> wrote:
>>
>> > The idea itself is useful.
>> >
>> Yes, it is.
>
> BTW it would be even more useful if it could print some of the
> statistics turbostat does (in particular frequency and C0 residency)
> Often you only care about cycles not idle, and the frequency
> tells you how fast the cycles happen.
>
You get C-state residency at the socket level with my perf uncore
patch.

This patch is just about helping with unbalance at the physical
core level.

> I think Cx could be added relatively easily as a software event,
> but frequency doesn't fit very well into the perf counting model,
> as it's really sampling.
>
> -Andi
