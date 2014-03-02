Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaCBBok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 20:44:40 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42590 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaCBBoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 20:44:39 -0500
Message-ID: <53128CFF.50301@linaro.org>
Date: Sun, 02 Mar 2014 09:44:31 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, james.hogan@imgtec.com,
        jason.low2@hp.com, viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: Re: [PATCH 04/11] sched: unify imbalance bias for target group
References: <1393293054-11378-1-git-send-email-alex.shi@linaro.org> <1393293054-11378-5-git-send-email-alex.shi@linaro.org> <20140225141407.GT9987@twins.programming.kicks-ass.net> <530E0531.7000303@linaro.org>
In-Reply-To: <530E0531.7000303@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would you like to give more comments? :)

Thanks!

On 02/26/2014 11:16 PM, Alex Shi wrote:
>> >Now I'm all for removing code; and so far the numbers aren't bad; but I
>> >don't like the complete muddle you make of things at all.
>> >
> Sorry, do you mean the load_idx removing is fine, if without this fixed
> bias? Or other suggestion here?

