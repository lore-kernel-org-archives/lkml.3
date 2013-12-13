Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3LMTu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:50:27 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:41423 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3LMTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:50:26 -0500
From: bsegall@google.com
To: Alex Shi <alex.shi@linaro.org>
Cc: pjt@google.com, Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com,
        fengguang.wu@intel.com, james.hogan@imgtec.com, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sched: remove cpu_load decay
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
	<20131203102650.GA8070@laptop.programming.kicks-ass.net>
	<52A668B8.5090709@linaro.org>
Date: Fri, 13 Dec 2013 11:50:17 -0800
In-Reply-To: <52A668B8.5090709@linaro.org> (Alex Shi's message of "Tue, 10 Dec
	2013 09:04:56 +0800")
Message-ID: <xm26fvpwo7ie.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi <alex.shi@linaro.org> writes:

> On 12/03/2013 06:26 PM, Peter Zijlstra wrote:
>> 
>> Paul, can you guys have a look at this, last time around you have a
>> regression with this stuff, so it would be good to hear from you.
>> 

This appears to be neutral on our search benchmark.
