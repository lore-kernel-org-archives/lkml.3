Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaKZWEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:04:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:53333 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaKZWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:04:02 -0500
Date: Wed, 26 Nov 2014 23:03:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH 0/9 v2] ftrace/x86: Clean up of mcount.S code
In-Reply-To: <20141125115003.856641273@goodmis.org>
Message-ID: <alpine.DEB.2.11.1411262249260.3961@nanos>
References: <20141125115003.856641273@goodmis.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Steven Rostedt wrote:
> I ran these through my test suite and they passed. Are these changes
> fine for you? If so, I'll include them in my 3.19 queue.
> 
> I still think the "band-aid patch" should go into 3.18 now, as it does
> fix a real bug, and is small and less likely to cause any regressions that
> this patch series might do. Which also makes it a candidate for stable.

Bah. It confused the hell out of me to figure out what that band aid
patch would be in the series.

So you are referring to the patch which I acked already, and which
caused Linus to stick his nose into that code.

Right, we really should (ignoring the ugliness) push that back into
stable. Having debug infrastructure which provides half baken
information is a real pain. I wasted days in the past just to figure
out that the tracer was giving me incomplete information or refusing
to stop when I wanted it to. I rather prefer a tool to be 'slow' than
disfunctional.

Thanks,

	tglx
