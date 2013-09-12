Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3ILGeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:34:50 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:52722 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3ILGes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:34:48 -0400
Message-ID: <52315F98.8020305@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 12:00:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] cpufreq: Prevent problems in update_policy_cpu()
 if last_cpu == new_cpu
References: <20130911201239.7832.72612.stgit@srivatsabhat.in.ibm.com> <20130911201334.7832.49714.stgit@srivatsabhat.in.ibm.com> <CAKohpomgd8X4UwFaVtJ49=CXTg2cyEirvD4_mj5ohqS5fk064Q@mail.gmail.com> <52315D7D.3030406@linux.vnet.ibm.com> <CAKohpoktJkAWf2xvRKmz3ZUW3wiRqHYdaR6d_HKsXZPXiiK53Q@mail.gmail.com>
In-Reply-To: <CAKohpoktJkAWf2xvRKmz3ZUW3wiRqHYdaR6d_HKsXZPXiiK53Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091206-6102-0000-0000-0000042AB675
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 12:01 PM, Viresh Kumar wrote:
> On 12 September 2013 11:51, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> That said, indeed currently there is no code in cpufreq that invokes the
>> function with last == new. So its not like we are masking an existing bug with
>> this patch. If you like, perhaps we can change this patch to print a warning
>> when it gets input values with last == new? That prevents disasters and also
>> warns when some code is buggy. Sounds like a win-win.
> 
> Exactly what I thought while I was midway reading your mail :)
> Probably a WARN().. So that we don't miss any other bugs :)
> 

Looking at the rate at which we are bumping into each others thoughts, I think
maybe we should switch from email to IRC ;-) ;-)

Regards,
Srivatsa S. Bhat

