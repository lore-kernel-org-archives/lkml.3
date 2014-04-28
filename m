Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaD1TSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:18:52 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55204 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaD1TSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:18:49 -0400
Message-ID: <535EA250.5060700@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 00:17:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: rjw@rjwysocki.net, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Cpufreq frequency serialization fixes
References: <20140425081728.10258.63980.stgit@srivatsabhat.in.ibm.com> <alpine.SOC.1.00.1404252028410.11626@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1404252028410.11626@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042818-1618-0000-0000-00000026801A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 10:59 PM, Meelis Roos wrote:
>> Meelis Roos reported hangs during boot in the longhaul cpufreq driver, after
>> commit 12478cf0c55 (cpufreq: Make sure frequency transitions are serialized).
>> The root-cause of this issue is the extra invocation of the
>> cpufreq_freq_transition_begin() and cpufreq_freq_transition_end() APIs in the
>> longhaul driver. I found similar issues in the powernow-k6 and powernow-k7
>> drivers as well. This patchset fixes the issue in all the 3 drivers.
>>
>>  Srivatsa S. Bhat (3):
>>       cpufreq, powernow-k7: Fix double invocation of cpufreq_freq_transition_begin/end
>>       cpufreq, powernow-k6: Fix double invocation of cpufreq_freq_transition_begin/end
>>       cpufreq, longhaul: Fix double invocation of cpufreq_freq_transition_begin/end
> 
> This set fixes it for me on VIA EPIA with longhaul.
> 

Thanks a lot for testing this Meelis! I'll send out the v2
soon.

Regards,
Srivatsa S. Bhat

