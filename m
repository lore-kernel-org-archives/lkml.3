Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3LMOKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:10:32 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:49654 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3LMOK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:10:27 -0500
Date: Fri, 13 Dec 2013 15:10:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/5] timekeeping: Fix CLOCK_TAI timer/nanosleep
 delays
Message-ID: <20131213141023.GC12379@gmail.com>
References: <1386789098-17391-1-git-send-email-john.stultz@linaro.org>
 <1386789098-17391-5-git-send-email-john.stultz@linaro.org>
 <20131212132518.GB16360@gmail.com>
 <52AA00E6.2040700@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AA00E6.2040700@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> > If the bugs extend to more than this two-liner then for -stable it 
> > might be better to just disable CLOCK_TAI (userspace can deal with 
> > it just fine), and queue up the right fixes for the next merge 
> > window or so.
> 
> I don't foresee further issues (famous last words, eh), but since I 
> was planning on keeping patch #4 and #5 for 3.14 anyway, we can wait 
> till those land upstream to decide if the two-liner is sufficient or 
> if disabling CLOCK_TAI in older -stable kernels is the right 
> approach. That sound ok?

Yeah, that certainly sounds good to me.

Thanks,

	Ingo
