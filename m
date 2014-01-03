Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaACAqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:46:24 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48652 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaACAqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:46:22 -0500
Message-ID: <52C6085C.3070206@codeaurora.org>
Date: Thu, 02 Jan 2014 16:46:20 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>
CC: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] sched_clock: Disable seqlock lockdep usage in sched_clock
References: <52C5E675.80701@linaro.org> <1388704274-5278-1-git-send-email-john.stultz@linaro.org> <1388704274-5278-2-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1388704274-5278-2-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/14 15:11, John Stultz wrote:
> Unforunately the seqlock lockdep enablmenet can't be used

s/Unforunately/Unfortunately/
s/enablmenet/enablement/

> in sched_clock, since the lockdep infrastructure eventually
> calls into sched_clock, which causes a deadlock.
>
> Thus, this patch changes all generic sched_clock usage
> to use the raw_* methods.
>
> Cc: Krzysztof Hałasa <khalasa@piap.pl>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Ingo Molnar <mingo@kernel.org>,
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

