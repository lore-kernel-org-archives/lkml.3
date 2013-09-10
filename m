Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3IJVKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:10:15 -0400
Received: from imap.thunk.org ([74.207.234.97]:57861 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3IJVKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:10:13 -0400
Date: Tue, 10 Sep 2013 17:10:09 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: John Stultz <john.stultz@linaro.org>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130910211009.GI29237@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
References: <10005394.BRCyBMYWy3@tauon>
 <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
 <20130910203853.GG29237@thunk.org>
 <522F851D.1040101@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522F851D.1040101@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 01:46:21PM -0700, John Stultz wrote:
> 
> We do read the clocksource fairly frequently though, so rather then
> re-reading on each interrupt, could you instead re-use the points at
> interrupt time where we already read the clocksource, like in
> hrtimer_interrupt()?

How often is that time updated?  Is there some documentation whree I
can understand how this works?  I confess to be pretty ignorant about
the details of how our time keeping systems work inside Linux.

Same question for sched_clock(); what are its guarantees, both in
terms of granularity and cost of overhead.  Is there any comprehensive
documentation that I should be reading?

Thanks,

						- Ted
