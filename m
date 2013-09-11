Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3IKSHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:07:39 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53758 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab3IKSHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:07:37 -0400
Message-ID: <5230B078.3070306@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 23:33:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan> <522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan> <52304439.3030301@linux.vnet.ibm.com> <523094CD.3000506@wwwdotorg.org>
In-Reply-To: <523094CD.3000506@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091117-8878-0000-0000-000008CD1272
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 09:35 PM, Stephen Warren wrote:
> On 09/11/2013 04:21 AM, Srivatsa S. Bhat wrote:
>> On 09/11/2013 04:04 AM, Rafael J. Wysocki wrote:
>>> On Tuesday, September 10, 2013 02:53:01 PM Stephen Warren wrote:
>>>> On 09/09/2013 05:14 PM, Rafael J. Wysocki wrote:
>>>>> On Monday, September 09, 2013 03:29:06 PM Stephen Warren wrote:
>>>>>> On 09/09/2013 02:24 PM, Rafael J. Wysocki wrote:
>>>>>>> On Monday, September 09, 2013 02:01:32 PM Stephen Warren wrote:
>>>>>>>> On 09/09/2013 02:01 PM, Rafael J. Wysocki wrote:
>>>>>>>>> On Monday, September 09, 2013 01:22:23 PM Stephen Warren wrote:
>>>>>>>>>> Viresh,
>>>>>>>>>>
>>>>>>>>>> I'm seeing the crash below when suspending my system for the second time.
> ...
>> Stephen, I went through the code and I think I found out what is going wrong.
>> Can you please try the following patch?
> 
> Unfortunately, I still see the exact same failure/backtrace with this
> patch applied.
> 

Oh, is it? Can you please give me the map of the related cpus on your
system? (ie., cat /sys/devices/system/cpu/cpu*/cpufreq/related_cpus for
each CPU.)

I must be missing something...
 
Regards,
Srivatsa S. Bhat

