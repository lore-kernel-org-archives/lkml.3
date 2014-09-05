Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbaIEHSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:18:42 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47249 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaIEHSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:18:41 -0400
Message-ID: <540963C6.8010702@linux.vnet.ibm.com>
Date: Fri, 05 Sep 2014 12:48:30 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Shreyas Prabhu <shreyas@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] powernv/cpufreq: Set the pstate of the last hotplugged
 out cpu in policy->cpus to minimum
References: <20140905065952.2831.66731.stgit@preeti.in.ibm.com> <20140905070134.2831.8175.stgit@preeti.in.ibm.com> <CAKohpokThCn3ze7KZ0zZNN8zyVCxjdL=pGBhWcAvVr9T23RxSg@mail.gmail.com>
In-Reply-To: <CAKohpokThCn3ze7KZ0zZNN8zyVCxjdL=pGBhWcAvVr9T23RxSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090507-7182-0000-0000-0000005F2882
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 12:37 PM, Viresh Kumar wrote:
> On 5 September 2014 12:31, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> 
>> +       smp_call_function_any(policy->cpus, set_pstate, &freq_data, 1);
> 
> We will surely have a single CPU alive at this point, so should we call
> this function on policy->cpu directly ?
> 
Yes that is better. Let me send out an updated version of this patch.

Regards
Preeti U Murthy

