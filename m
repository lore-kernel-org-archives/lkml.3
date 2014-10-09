Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaJIJmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:42:37 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:41978 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaJIJm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:42:29 -0400
Message-ID: <54365886.7010506@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2014 15:12:30 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: svaidy@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        rjw@rjwysocki.net, lizefan@huawei.com,
        Anton Blanchard <anton@samba.org>, Tejun Heo <tj@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
References: <CAC4Lta2AS6M5upg8n9Qu5+1pqCMF3j8_cYuLAS1DH9C_BQP0PA@mail.gmail.com> <54361922.8070808@linux.vnet.ibm.com>
In-Reply-To: <54361922.8070808@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100909-4790-0000-0000-0000042E9DC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 10:42 AM, Preeti U Murthy wrote:
> Hi Raghu,

> remove_tasks_in_empty_cpuset() is called on the legacy hierarchy when
> the cpuset becomes empty, hence we require it. But you are right its not
> called on the default hierarchy.

My point was if legacy hierarchy follows unified hierarchy in effective
cpuset handling, we will never endup with a empty effective cpuset and
hence your patch could remove the remove_tasks_in_empty_cpuset() part
too..

