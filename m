Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaI2PL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:11:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:54386 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbaI2PL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:11:27 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] sched/nohz: add debugfs control over sched_tick_max_deferment
References: <1411760732-14102-1-git-send-email-khilman@kernel.org>
	<20140927165938.GB21729@lerouge>
Date: Mon, 29 Sep 2014 08:11:25 -0700
In-Reply-To: <20140927165938.GB21729@lerouge> (Frederic Weisbecker's message
	of "Sat, 27 Sep 2014 18:59:39 +0200")
Message-ID: <7hh9zq31ia.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Fri, Sep 26, 2014 at 12:45:32PM -0700, Kevin Hilman wrote:
>> From: Kevin Hilman <khilman@linaro.org>
>> 
>> Allow debugfs override of sched_tick_max_deferment in order to ease
>> finding/fixing the remaining issues with full nohz.
>> 
>> The value to be written is in jiffies, and -1 means the max deferment
>> is disabled (scheduler_tick_max_deferment() returns KTIME_MAX.)
>> 
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>
> So, I'm worried that it becomes a hack that everybody uses to shutdown
> the tick completely then nobody will come and fix the issue that prevents
> from doing it properly.

OK.

> I seriously doubt this will be used for development purpose to help
> fixing the real problem. 

Well, that's what I was using it for, until I was distracted by other
tasks.

> Quite the opposite. If developers want to do
> testing, they can as well comment out the call to scheduler_max_tick_deferment().

OK, fair enough.

Thanks,

Kevin
