Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaBUENa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:13:30 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49195 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaBUEN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:13:28 -0500
Date: Thu, 20 Feb 2014 20:13:25 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, anton@nomsg.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH v3 4/6] timerfd: Factor out timer-type unspecific
 timerfd_expire()
Message-ID: <20140221041325.GA19817@teo>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
 <1392885633-7787-5-git-send-email-a.perevalov@samsung.com>
 <alpine.DEB.2.02.1402201136500.4468@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402201136500.4468@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 11:52:03AM +0100, Thomas Gleixner wrote:
> > From: Anton Vorontsov <anton@enomsg.org>
> > 
> > There is nothing hrtimer-specific inside the timerfd_tmrproc(), except
> > the function prototype. We're about to add other timer types, so factor
> > out generic timerfd_expire() helper from timerfd_tmrproc().
> 
> This changelog is completely useless. How is timerfd_tmrproc, which is
> not a function but a function pointer, related to the patch?
> 
> Moving duplicated code to a common function is nice, but ....

> > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> > Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
... 
> Warnings are there to be ignored and testing of user space
> interfaces after a change is overrated, right?
> 
> Aside of that you just blindly copied the original code w/o fixing up
> the now unnecessary line breaks.

Alexey,

While I appreciate the desire to be careful with authorship and stuff,
please remove my name as an author of this patch -- the current code has
nothing to do with my original work, and I surely don't want to take any
responsibility for it. This is a common practice if you modify someone's
patch to a great extend.

Thomas is bashing the thing, which has my name on it; although _my_ patch
did not produce any warnings, came with a completely different changelog,
and served completely different purposes.

Instead of rushing with resending yet another series, please actually read
Thomas' review.

Thanks,

Anton
