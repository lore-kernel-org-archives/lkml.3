Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaEUMeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:34:12 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44940 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:34:09 -0400
Message-ID: <537C9CF3.60503@linux.vnet.ibm.com>
Date: Wed, 21 May 2014 18:02:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>, rjw@rjwysocki.net, viresh.kumar@linaro.org
CC: ego@linux.vnet.ibm.com, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end
References: <20140505072129.14454.25747.stgit@srivatsabhat.in.ibm.com> <alpine.SOC.1.00.1405051152370.17122@math.ut.ee> <5367553C.1040701@linux.vnet.ibm.com>
In-Reply-To: <5367553C.1040701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052112-0260-0000-0000-000004FCBD97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 02:39 PM, Srivatsa S. Bhat wrote:
> On 05/05/2014 02:23 PM, Meelis Roos wrote:
>>>
>>> Changes in v3:
>>> Expanded the comment in the code to briefly mention why ASYNC_NOTIFICATION
>>> drivers are left out from the check, as suggested by Gautham R. Shenoy.
>>> No code changes in this version.
>>>
>>> v2: https://lkml.org/lkml/2014/4/29/283
>>> v1: https://lkml.org/lkml/2014/4/28/469
>>
>> Seems to work on VIA EPIA with 3.15-rc2 (no other cpufreq fixes):
>>
> 
> Great! Thanks a lot for testing this!
> 
> Rafael/Viresh, can you please add Meelis' Tested-by while taking
> this patch?

Rafael, any thoughts on this patch?

It has been Acked by Viresh and tested by Meelis. Hope you'll consider
picking up this patch for 3.16.

Thank you!

Regards,
Srivatsa S. Bhat

