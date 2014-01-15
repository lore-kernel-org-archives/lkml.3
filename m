Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaAOOiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:38:06 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63619 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaAOOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:38:04 -0500
Message-ID: <52D69D44.4090504@linaro.org>
Date: Wed, 15 Jan 2014 22:37:56 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, daniel.lezcano@linaro.org
CC: mingo@redhat.com, tglx@linutronix.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org> <20140115073533.GU31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140115073533.GU31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 03:35 PM, Peter Zijlstra wrote:
> On Wed, Jan 15, 2014 at 12:07:59PM +0800, Alex Shi wrote:
>> Currently we just try to find least load cpu. If some cpus idled,
>> we just pick the first cpu in cpu mask.
>>
>> In fact we can get the interrupted idle cpu or the latest idled cpu,
>> then we may get the benefit from both latency and power.
>> The selected cpu maybe not the best, since other cpu may be interrupted
>> during our selecting. But be captious costs too much.
> 
> No, we should not do anything like this without first integrating
> cpuidle.
> 
> At which point we have a sane view of the idle states and can make a
> sane choice between them.
> 


Daniel,

Any comments to make it better?

-- 
Thanks
    Alex
