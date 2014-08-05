Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaHEPpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:45:34 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:52251 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaHEPpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140805152540.GC19379@twins.programming.kicks-ass.net>
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com>
	<1406659999-13974-3-git-send-email-Waiman.Long@hp.com>
	<20140805132837.GA19379@twins.programming.kicks-ass.net>
	<CAKocOOMa89+Ej0rk-LyQLBcwDvLtsXq7x+oPwBMS1N61kKUwQg@mail.gmail.com>
	<20140805144108.GK9918@twins.programming.kicks-ass.net>
	<53E0EDD2.50600@canonical.com>
	<20140805145437.GL9918@twins.programming.kicks-ass.net>
	<CAKocOOM=c2jaW_D27Z_iHoSzknp38j0gh_Exa3iTf5CzFkmPJA@mail.gmail.com>
	<20140805152540.GC19379@twins.programming.kicks-ass.net>
Date: Tue, 5 Aug 2014 09:45:32 -0600
Message-ID: <CAKocOON_RQuKoHTkJKv3iMV5=wszEqGfBGiZ__WW7M902qsf2A@mail.gmail.com>
Subject: Re: [PATCH 2/2 v6] locking/selftest: Support queued rwlock
From: Shuah Khan <shuahkhan@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 9:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 05, 2014 at 09:05:53AM -0600, Shuah Khan wrote:
>> Maybe if tools doesn't sounds right, we could move testing from under tools
>> and have it be testing
>
> No, tools/testing/ is all userspace stuff afaict.
>
>> We have several selftests spread around in the kernel tree. It makes it easier
>> to pull them under a single make target devtest. I sent in a patch add devtest
>> target that runs tests that are under tools/testing/selftests a couple of
>> weeks ago, hopefully it will be included in 3.17. I am working towards pulling
>> more kernel selftests that exist under this devtest umbrella. That is
>> the motivation
>
> A link to the patch might've been useful.. but no that's pointless,
> there is no userspace component to locking-selftest, so your build/run
> target is bloody pointless.

Makes sense. Thanks,
-- Shuah
