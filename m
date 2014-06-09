Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaFIVYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:24:34 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:55456 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754500AbaFIVYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:24:30 -0400
Message-ID: <53962609.6080102@semaphore.gr>
Date: Tue, 10 Jun 2014 00:24:25 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] cpufreq: intel_pstate: Make intel_pstate_kobject
 local
References: <53962096.1060202@semaphore.gr> <alpine.DEB.2.02.1406091405540.30620@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406091405540.30620@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 12:07 πμ, David Rientjes wrote:
> On Tue, 10 Jun 2014, Stratos Karafotis wrote:
> 
>> Since we never remove sysfs entry, we can make the intel_pstate_kobject
>> local.
>>
> 
> For even more savings, this function and 
> intel_pstate_debug_expose_params() can be annotated with __init and freed 
> after bootstrap.

Thanks for your comment, David!
I will do this in v2.


Stratos

