Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaHBF3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 01:29:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaHBF3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 01:29:31 -0400
Message-ID: <53DC7715.4080008@redhat.com>
Date: Sat, 02 Aug 2014 07:28:53 +0200
From: Jirka Hladky <jhladky@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: Peter Zijlstra <peterz@infradead.org>, Aaron Lu <aaron.lu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Hai Huang <hhuang@redhat.com>, Kamil Kolakowski <kkolakow@redhat.com>
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1% proc-vmstat.numa_hint_faults_local
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>	 <53D72FF5.90908@intel.com> <20140729023940.37b6aebc@annuminas.surriel.com>	 <20140731104241.GA9918@twins.programming.kicks-ass.net>	 <20140731155723.GY3588@twins.programming.kicks-ass.net>	 <53DA6BDA.8080000@redhat.com> <1406926000.16021.6.camel@buesod1.americas.hpqcorp.net> <53DC06FA.8030104@redhat.com> <53DC6641.2050904@redhat.com>
In-Reply-To: <53DC6641.2050904@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2014 06:17 AM, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 08/01/2014 05:30 PM, Jirka Hladky wrote:
>
>> I see the regression only on this box. It has 4 "Ivy Bridge-EX"
>> Xeon E7-4890 v2 CPUs.
>>
>> http://ark.intel.com/products/75251
>> http://en.wikipedia.org/wiki/List_of_Intel_Xeon_microprocessors#.22Ivy_Bridge-EX.22_.2822_nm.29_Expandable_2
>>
>>
>>
>> Please rerun the test on box with Ivy Bridge CPUs. It seems that
>> older CPU generations are not affected.
> That would have been good info to know :)
>
> I've been spending about a month trying to reproduce your issue on a
> Westmere E7-4860.
>
> Good thing I found all kinds of other scheduler issues along the way...

Hi Rik,

till recently I have seen the regression on all systems.

With the latest kernel, only Ivy Bridge system seems to be affected.

Jirka

