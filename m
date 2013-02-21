Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3BUXGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:06:53 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46881 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3BUXGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:06:52 -0500
Message-ID: <1361488009.32484.1.camel@edumazet-glaptop>
Subject: Re: [RFC patch 0/8] timekeeping: Implement shadow timekeeper to
 shorten in kernel reader side blocking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 21 Feb 2013 15:06:49 -0800
In-Reply-To: <20130221220147.719832397@linutronix.de>
References: <20130221220147.719832397@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 22:51 +0000, Thomas Gleixner wrote:

> Now the obvious question whether this is worth the trouble can be
> answered easily. Preempt-RT users and HPC folks have complained about
> the long write hold time of the timekeeping seqcount since years and a
> quick test on a preempt-RT enabled kernel shows, that this series
> lowers the maximum latency on the non-timekeeping cores from 8 to 4
> microseconds. That's a whopping factor of 2. Defintely worth the
> trouble!

Thanks for doing this !


