Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaHEPFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:05:55 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:49059 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaHEPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140805145437.GL9918@twins.programming.kicks-ass.net>
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com>
	<1406659999-13974-3-git-send-email-Waiman.Long@hp.com>
	<20140805132837.GA19379@twins.programming.kicks-ass.net>
	<CAKocOOMa89+Ej0rk-LyQLBcwDvLtsXq7x+oPwBMS1N61kKUwQg@mail.gmail.com>
	<20140805144108.GK9918@twins.programming.kicks-ass.net>
	<53E0EDD2.50600@canonical.com>
	<20140805145437.GL9918@twins.programming.kicks-ass.net>
Date: Tue, 5 Aug 2014 09:05:53 -0600
Message-ID: <CAKocOOM=c2jaW_D27Z_iHoSzknp38j0gh_Exa3iTf5CzFkmPJA@mail.gmail.com>
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

On Tue, Aug 5, 2014 at 8:54 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 05, 2014 at 04:44:34PM +0200, Maarten Lankhorst wrote:
>> op 05-08-14 16:41, Peter Zijlstra schreef:
>
>> >> A bit off topic for this patch, however relevant for tests in general.
>> >> Is there a reason why these locking selftests need to be under lib?
>> >> Can they be consolidated under tools/testing/selftests?
>> > tools/ seems wrong as its very much not userspace.
>> Could be moved to kernel/locking though now that all other locking moved there. :-)
>
> Yes, I suppose we could do that; IIRC the reason I left it where it is
> is because there are more tests in lib/.

Maybe if tools doesn't sounds right, we could move testing from under tools
and have it be testing

We have several selftests spread around in the kernel tree. It makes it easier
to pull them under a single make target devtest. I sent in a patch add devtest
target that runs tests that are under tools/testing/selftests a couple of
weeks ago, hopefully it will be included in 3.17. I am working towards pulling
more kernel selftests that exist under this devtest umbrella. That is
the motivation
behind starting this conversation. :)

-- Shuah
