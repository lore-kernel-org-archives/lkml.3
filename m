Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaCED3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:29:47 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:57282 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718AbaCED3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:29:46 -0500
Date: Tue, 4 Mar 2014 21:29:43 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/48] percpu: Consistent per cpu operations V4
In-Reply-To: <20140304142759.a6849728754eb553b0bd33d3@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1403042127330.3742@nuc>
References: <20140214201841.826179349@linux.com> <20140304142759.a6849728754eb553b0bd33d3@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014, Andrew Morton wrote:

> This series is structured as
>
> [patch 1]: make changes whcih trigger lots of runtime warnings
> [patch 2-n]: fix up those warnings
>
> yes?

Nope. The warning causing things are eliminated before the checks are
introduced. The first patch adds new functionality. The following patches
fix warnings that will otherwise spew over the logs and then we add the
checks.

> So we're proposing adding a 48-patch bisection hole in which scary
> warnings will be emitted.

That is not the case.

What could occur is that there could be kernel configurations which
trigger warnings that so far have not been tested.


> In linux-next arch/arm/mach-msm/timer.c gets moved to
> drivers/clocksource/qcom-timer.c, which I fixed up.  Apart from that it
> all still merges OK...

Great.

