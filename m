Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab3ANIoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:44:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:37967 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab3ANIox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:44:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,466,1355126400"; 
   d="scan'208";a="243481096"
Message-ID: <50F3C5C2.8070003@intel.com>
Date: Mon, 14 Jan 2013 16:45:54 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 22/22] sched: lazy powersaving balance
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-23-git-send-email-alex.shi@intel.com> <877gngnoou.fsf@sejong.aot.lge.com>
In-Reply-To: <877gngnoou.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 04:39 PM, Namhyung Kim wrote:
> On Sat,  5 Jan 2013 16:37:51 +0800, Alex Shi wrote:
>> +	/*
>> +	 * The situtatoin isn't egligible for performance balance. If this_cpu
> 
> s/situtatoin/situation/
> 
> s/egligible/eligible/
> 

Thanks a lot!
>> +	 * is not egligible or the timing is not suitable for lazy powersaving
> 
> Thanks,
> Namhyung
> 
> 
>> +	 * balance, we will stop both powersaving and performance balance.
>> +	 */


-- 
Thanks Alex
