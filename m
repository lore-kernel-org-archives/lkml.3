Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3JNQNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:13:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:54964 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab3JNQNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="307582156"
Message-ID: <525C1817.1050909@linux.intel.com>
Date: Mon, 14 Oct 2013 09:13:11 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for
 kworker threads
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com> <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com> <20131014133356.GN3081@twins.programming.kicks-ass.net> <20131014161011.GO31039@e103034-lin>
In-Reply-To: <20131014161011.GO31039@e103034-lin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 9:10 AM, Morten Rasmussen wrote:
> On Mon, Oct 14, 2013 at 02:33:56PM +0100, Peter Zijlstra wrote:
>> On Fri, Oct 11, 2013 at 06:19:14PM +0100, Morten Rasmussen wrote:
>>> Removing power hints for kworker threads enables easier use of
>>> workqueues in the power driver late callback. That would otherwise
>>> lead to an endless loop unless it is prevented in the power driver.
>>
>> There's many kworker users; some of them actually consume lots of
>> cputime. Therefore how did you come to the conclusion that excepting all
>> users was the better choice of a little added complexity in the one
>> place where it actually matters?
>
> Agreed that it is not ideal. I will find a better solution for this
> problem.
>

can you explain which architectures we're talking about that need this?
is it only old stuff, or is there anything current ?

