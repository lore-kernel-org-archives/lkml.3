Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3LNMyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:54:08 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34714 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab3LNMyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:54:06 -0500
Message-ID: <52AC54E0.5040904@linaro.org>
Date: Sat, 14 Dec 2013 20:53:52 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: bsegall@google.com
CC: pjt@google.com, Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com,
        fengguang.wu@intel.com, james.hogan@imgtec.com, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sched: remove cpu_load decay
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>	<20131203102650.GA8070@laptop.programming.kicks-ass.net>	<52A668B8.5090709@linaro.org> <xm26fvpwo7ie.fsf@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <xm26fvpwo7ie.fsf@sword-of-the-dawn.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 03:50 AM, bsegall@google.com wrote:
> Alex Shi <alex.shi@linaro.org> writes:
> 
>> On 12/03/2013 06:26 PM, Peter Zijlstra wrote:
>>>
>>> Paul, can you guys have a look at this, last time around you have a
>>> regression with this stuff, so it would be good to hear from you.
>>>
> 
> This appears to be neutral on our search benchmark.
> 


Thanks for testing!

-- 
Thanks
    Alex
