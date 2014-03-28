Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaC1HH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:07:57 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46199 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaC1HH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:07:56 -0400
Date: Fri, 28 Mar 2014 08:07:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] time: Revert to calling clock_was_set_delayed() while in
 irq context
Message-ID: <20140328070750.GB30107@gmail.com>
References: <1395963049-11923-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395963049-11923-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> Ingo,
> 
> After testing a patch queued for 3.15, I noticed there was a WARNON 
> message that I realized was triggered by one of my patches that came 
> in the 3.14 merge window. I'm not very happy to find this now, but 
> sadly here it is. The fix is luckily fairly simple and just falls 
> back to previous behavior.
> 
> For tip/timers/urgent.

No problem - I've applied your fix to timers/urgent and will get it to 
Linus later today, after a bit of testing.

Thanks,

	Ingo
