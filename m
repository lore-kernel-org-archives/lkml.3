Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3HBOtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:49:47 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52721 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3HBOtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:49:45 -0400
Message-ID: <51FBC629.9080908@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 20:16:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references
 for additional policy CPUs
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com> <CAKohpon7jyJWhf+j-M6Nuqy-AaY73YUpBpt-1uh12e_SYRv2bQ@mail.gmail.com> <5361062.ChI1FUI32W@vostro.rjw.lan> <CAKohpo=KhzFiiihCPfZ9kAm4rx1ZUfgWDJPQkhCgM5u2Gj3+uA@mail.gmail.com>
In-Reply-To: <CAKohpo=KhzFiiihCPfZ9kAm4rx1ZUfgWDJPQkhCgM5u2Gj3+uA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080214-8878-0000-0000-000008385909
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 08:08 PM, Viresh Kumar wrote:
> On 2 August 2013 19:01, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> Care to add a changelog?
>>
>> I'll apply this on top of my $subject patch, then.
> 
> I thought you will merge this one with your patch, but there is no
> harm in getting one more on my name :)
> 
> Changelog is (patch attached):
> 
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Fri, 2 Aug 2013 16:17:33 +0530
> Subject: [PATCH] cpufreq: Pass policy to cpufreq_add_policy_cpu()
> 
> Caller of cpufreq_add_policy_cpu() already has pointer to policy structure and
> so there is no need to find it again in cpufreq_add_policy_cpu(). Lets pass it
> directly.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

The patch looks good.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  drivers/cpufreq/cpufreq.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 

