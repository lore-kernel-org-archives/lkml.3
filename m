Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaE0DRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 23:17:13 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39723 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaE0DRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 23:17:10 -0400
Message-ID: <53840368.4030004@linux.vnet.ibm.com>
Date: Tue, 27 May 2014 08:45:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: viresh.kumar@linaro.org, svaidy@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com> <2902116.OdbNv5KQzQ@vostro.rjw.lan>
In-Reply-To: <2902116.OdbNv5KQzQ@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052703-1396-0000-0000-000004EA1D59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 04:57 AM, Rafael J. Wysocki wrote:
> Hi Srivatsa,
> 
> On Tuesday, May 27, 2014 02:23:38 AM Srivatsa S. Bhat wrote:
>> Cpufreq governors like the ondemand governor calculate the load on the CPU
>> periodically by employing deferrable timers. A deferrable timer won't fire
>> if the CPU is completely idle (and there are no other timers to be run), in
>> order to avoid unnecessary wakeups and thus save CPU power.
>>
>> However, the load calculation logic is agnostic to all this, and this can
>> lead to the problem described below.
> 
> This is subtle enough that I need some more time to chew on it, but since the
> merge window is coming, I'm not sure when that's going to happen honestly.
>

Sure, I completely understand. Please take your time, no hurry!

Thank you very much!

Regards,
Srivatsa S. Bhat

