Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3EFHSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:18:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:19226 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab3EFHSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:18:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,619,1363158000"; 
   d="scan'208";a="237352626"
Message-ID: <51875944.9020409@intel.com>
Date: Mon, 06 May 2013 15:18:28 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [PATCH v5 2/7] sched: remove SMP cover for runnable variables
 in cfs_rq
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-3-git-send-email-alex.shi@intel.com> <51872D7F.30909@linux.vnet.ibm.com>
In-Reply-To: <51872D7F.30909@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 12:11 PM, Preeti U Murthy wrote:
> Hi Alex,
> 
> You might want to do the below for struct sched_entity also?
> AFAIK,struct sched_entity has struct sched_avg under CONFIG_SMP.
> 

Ops, why it passed my UP config building? Anyway will check and test more.
Thanks Preeti!
-- 
Thanks
    Alex
