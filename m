Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbaGQWci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:32:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:44200 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaGQWch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:32:37 -0400
Date: Fri, 18 Jul 2014 00:32:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V2 00/64] timekeeping: 2038, optimizations, NMI safe
 accessors
In-Reply-To: <20140716205018.175419210@linutronix.de>
Message-ID: <alpine.DEB.2.10.1407180018530.24854@nanos>
References: <20140716205018.175419210@linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014, Thomas Gleixner wrote:
> The series is against tip/timers/core. It's also available in git at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tglx/timers/core

Anyone, who pulled from there, please do again. I just got aware that
the branch was stale.

I could swear that I updated it and according to my bash history I
really did a force push on that branch and a verify that
origin/tglx/timers/core is the same as tglx/timers/core, that's the
same procedure I use before sending out a pull request to Linus - got
burned once not doing that :)

The same thing happened about half a year ago, and looking at the mail
thread it was also a forced update, i.e. git push -f

I'm not blaming anyone except me as long as I can't be sure that my
scripting around git is not to blame.

Sorry for the inconveniance!

Thanks,

	tglx

