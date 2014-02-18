Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaBRGSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:18:02 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35314 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaBRGSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:18:00 -0500
Message-ID: <5302FB0B.5090103@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 14:17:47 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, peterz@infradead.org,
        morten.rasmussen@arm.com
CC: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, jason.low2@hp.com, viresh.kumar@linaro.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 0/11] remove cpu_load in rq
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org> <5302E6FA.508@linux.vnet.ibm.com> <5302F7B7.60802@linaro.org>
In-Reply-To: <5302F7B7.60802@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021806-5816-0000-0000-00000C547BCB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 02:03 PM, Alex Shi wrote:
[snip]
>>
> 
> I reviewed my patch again. Also didn't find suspicious line for the
> following rcu stall.  Will wait for your report. :)

Posted, it will be triggered in pure tip/master, your patch set was
innocent ;-)

Regards,
Michael Wang

>>
> 

