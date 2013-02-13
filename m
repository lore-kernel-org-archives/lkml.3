Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab3BMPXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:23:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:28035 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117Ab3BMPXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:23:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,658,1355126400"; 
   d="scan'208";a="201935263"
Message-ID: <511BAFDB.6050908@intel.com>
Date: Wed, 13 Feb 2013 23:23:07 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 08/18] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <1358996820-23036-9-git-send-email-alex.shi@intel.com> <1360664874.4485.18.camel@laptop>
In-Reply-To: <1360664874.4485.18.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:27 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>> Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
>> we can use runnable load variables.
>>
> It would be nice if we could quantify the performance hit of doing so.
> Haven't yet looked at later patches to see if we remove anything to
> off-set this.
> 

In our rough testing, no much clear performance changes.

-- 
Thanks
    Alex
