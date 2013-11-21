Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3KUXyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:54:02 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63933 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3KUXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:54:00 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/17] Convert ARM sched_clock users to sched_clock_register()
References: <1384557985-9414-1-git-send-email-sboyd@codeaurora.org>
	<87li0h8i70.fsf@linaro.org> <528E955C.7090205@codeaurora.org>
Date: Thu, 21 Nov 2013 15:53:57 -0800
In-Reply-To: <528E955C.7090205@codeaurora.org> (Stephen Boyd's message of
	"Thu, 21 Nov 2013 15:21:00 -0800")
Message-ID: <87a9gx8g6i.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> On 11/21/13 15:10, Kevin Hilman wrote:
>> Hi Stephen,
>>
>> Stephen Boyd <sboyd@codeaurora.org> writes:
>>
>>> Olof,
>>>
>>> Please consider picking up these simple conversion patches. They
>>> were sent a few months back[1] but I didn't keep pushing them due
>>> to the complex path to mainline that the core patches took. I've
>>> picked up the acks and resent. Now that the core kernel changes have
>>> landed in Linus' tree it's much easier to pull these changes in.
>> Just to clarify, are the dependencies in v3.12? or were they merged for
>> the v3.13 merge window and just recently it Linus' tree.
>
> The dependencies are not in 3.12. They just hit Linus' tree this merge
> window (3.13). Ingo brought it into tip at commit
> 68e90740284c69292881cd38c7ece6f09a18a58f and Linus took it at commit
> 87093826aa0172d9135ca1f301c4298a258ceee6.

OK, thanks for the clarification.

I've applied these to an soc/sched_clock branch which is based on
tip/timers-core-for-linus and merged it into our to-build branch so it
gets some early boot/build coverage.  Once -rc1 is out, we'll start
adding non-fixes to for-next and this will be among the first branches
there (assuming the build/boot doesn't show any problems.)

Kevin
