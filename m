Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbbAKLlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:41:32 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:61163 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbAKLla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:41:30 -0500
Date: Sun, 11 Jan 2015 12:41:24 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 00/10][RFC] Increased clocksource validation and cleanups
Message-ID: <20150111114124.GD4467@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 04:34:18PM -0800, John Stultz wrote:
> So this series is the result of earlier discussions with Linus
> and his suggestions around improvements to clocksource validation
> in the hope we can more easily catch bad hardware.

Why penalize most users just because of a random hardware failure?
Why not make the "catching code" a compile time option?

Thanks,
Richard

