Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3BUKfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:35:21 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:45477 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3BUKfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130220220802.GE23293@tassilo.jf.intel.com>
References: <1361355312-3323-1-git-send-email-eranian@google.com>
	<20130220154344.GD23293@tassilo.jf.intel.com>
	<CABPqkBS58oMw8Gs7AVN0OMvLuFYH4iXXRHBx3Ep1Mbru=gLVtg@mail.gmail.com>
	<20130220220802.GE23293@tassilo.jf.intel.com>
Date: Thu, 21 Feb 2013 11:35:17 +0100
Message-ID: <CABPqkBSDma_=MGWAcG_6d04r_7XOxxjRg3ju69Oz8OFzKcDXxA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: add Intel IvyBridge event scheduling constraints
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

On Wed, Feb 20, 2013 at 11:08 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> > Except for LDM_PENDING the CYCLE_ACTIVITY events have been also added to Sandy Bridge.
>> > So it should be also added there.
>> >
>> As far as I know and I double-checked the documentation I have, there
>> is no CYCLE_ACTIVITY
>> event on SNB or SNB-EP.
>
> page 19-28 in the Jan 2013 SDM. It was only recently added.
> It's only a subset of what you have on Ivy Bridge.
>
I have confirmed that this is a typo in the SDM. This event is not
available on SandyBridge.

>>
>> > In fact I think you can still share the table because it would just add some
>> > non existent events to Sandy Bridge, which is a noop.
>> >
>> I don't see the point of this, except saving a few bytes. Isn't it
>> better to keep each PMU separate?
>
> Ok, as long as you update the SNB table too.
>
> -Andi
