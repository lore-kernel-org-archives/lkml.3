Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbbALUtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:49:42 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:53943 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbbALUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:49:41 -0500
Date: Mon, 12 Jan 2015 21:49:36 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/10] time: Cap clocksource reads to the clocksource
 max_cycles value
Message-ID: <20150112204936.GE4233@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
 <1420850068-27828-7-git-send-email-john.stultz@linaro.org>
 <20150111124146.GA15387@localhost.localdomain>
 <CALAqxLX2Th7-kEM1vQBJn5hnPTJ5ujg-Zx-aa-oOhP5cb=hXLQ@mail.gmail.com>
 <20150112203006.GB4233@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112203006.GB4233@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:30:07PM +0100, Richard Cochran wrote:
> On Mon, Jan 12, 2015 at 10:54:50AM -0800, John Stultz wrote:
> > You say the tick should be scheduled before the clocksource wraps -
> > but we have logic to do that.
> 
> Well that is a shame.

Arg, I mean, not a shame that we have logic for that, but rather that
the logic is not reliable enough!

Sorry
Richard


