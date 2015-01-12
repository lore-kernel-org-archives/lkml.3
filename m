Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbbALUQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:16:36 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43679 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbbALUQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:16:35 -0500
Date: Mon, 12 Jan 2015 21:16:25 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/10] clocksource: Remove clocksource_max_deferment()
Message-ID: <20150112201625.GA4233@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
 <1420850068-27828-4-git-send-email-john.stultz@linaro.org>
 <20150111114724.GE4467@localhost.localdomain>
 <CALAqxLWnAQhVzJH4VzVN9oyYAPu88R1jX3CvDatrra8XKC1djw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLWnAQhVzJH4VzVN9oyYAPu88R1jX3CvDatrra8XKC1djw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:36:58AM -0800, John Stultz wrote:
> So, the first patch had a cleanup which removed case where the max
> mult value was being calculated assuming nanoseconds was a s64 instead
> of a u64, which resulted in the max_idle_ns to be halved. So this
> doesn't actually cost us more over what the current kernel does.

Ok, fine, missed that.

Thanks
Richard
