Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaAFKLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:11:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55195 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaAFKLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:11:19 -0500
Date: Mon, 6 Jan 2014 11:10:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] seqlock: Use raw_ prefix instead of _no_lockdep
Message-ID: <20140106101039.GD31570@twins.programming.kicks-ass.net>
References: <52C5E675.80701@linaro.org>
 <1388704274-5278-1-git-send-email-john.stultz@linaro.org>
 <CA+55aFxv8wTRifZ9iHn-tCfUqwpJZmLiF7QU=Pc6dVa8QnTyCQ@mail.gmail.com>
 <52C755AF.5030402@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C755AF.5030402@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 04:28:31PM -0800, John Stultz wrote:
> On 01/02/2014 04:50 PM, Linus Torvalds wrote:
> > On Thu, Jan 2, 2014 at 3:11 PM, John Stultz <john.stultz@linaro.org> wrote:
> >> Linus disliked the _no_lockdep() naming, so instead
> >> use the more-consistent raw_* prefix to the non-lockdep
> >> enabled seqcount methods.
> >>
> >> This also adds raw_ methods for the write operations
> >> as well, which will be utilized in a following patch.
> > Ack on this and on 2/2. I'm assuming I'll get them through the -tip
> > tree, which is where the problem came from. No?
> 
> It seems Peter or Ingo are still on holiday. Hopefully they will be back
> on Monday to queue these.

Done! thanks!
