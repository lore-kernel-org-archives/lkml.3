Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbbALSWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:22:16 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:48648 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbbALSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:22:12 -0500
MIME-Version: 1.0
In-Reply-To: <20150111114124.GD4467@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
	<20150111114124.GD4467@localhost.localdomain>
Date: Mon, 12 Jan 2015 10:22:11 -0800
Message-ID: <CALAqxLW7xymopptsq5zWMyY_P25WmNvKne4u_LH-kZKK25N5fQ@mail.gmail.com>
Subject: Re: [PATCH 00/10][RFC] Increased clocksource validation and cleanups
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 3:41 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Fri, Jan 09, 2015 at 04:34:18PM -0800, John Stultz wrote:
>> So this series is the result of earlier discussions with Linus
>> and his suggestions around improvements to clocksource validation
>> in the hope we can more easily catch bad hardware.
>
> Why penalize most users just because of a random hardware failure?
> Why not make the "catching code" a compile time option?

Yea, I've not looked at the actual performance impact yet, but things
like the read-time capping (which is in the hot path) could be put
under a debug config. Thanks for the suggestion!
-john
