Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3CRVcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:32:13 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:49141 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab3CRVcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:32:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130318142623.a6a9dd7be1ca9dcd1cd0caec@linux-foundation.org>
References: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
	<1363366442-11494-5-git-send-email-fweisbec@gmail.com>
	<20130318142623.a6a9dd7be1ca9dcd1cd0caec@linux-foundation.org>
Date: Mon, 18 Mar 2013 22:32:07 +0100
Message-ID: <CAFTL4hwbnTML3tSaAfSSJ3ybEp0O28zwcFmVDjZzE8_c2kXXjQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] selftests: Add basic posix timers selftests
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 15 Mar 2013 17:54:02 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Add some initial basic tests on a few posix timers
>> interface such as setitimer() and timer_settime().
>>
>> These simply check that expiration happens in a reasonable
>> timeframe after expected elapsed clock time (user time,
>> user + system time, real time, ...).
>>
>> This is helpful for finding basic breakages while hacking
>> on this subsystem.
>>
>> ...
>>
>>  tools/testing/selftests/timers/Makefile       |    8 +
>
> I wonder if this should be tools/testing/posix-timers/, to leave room
> in the namespace for other varieties of timer.

In fact I called it timers/ on purpose such that some more timers
related selftests can be added and gathered in the future. But I don't
mind if we keep very single purpose directories like
tools/testing/posix-timers/
