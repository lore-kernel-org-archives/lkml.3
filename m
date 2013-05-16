Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3EPHfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:35:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:5280 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab3EPHfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:35:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="314484120"
Message-ID: <51948C2F.6050804@intel.com>
Date: Thu, 16 May 2013 15:35:11 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch 0/8]: use runnable load avg in balance
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <51948AD4.3020104@linux.vnet.ibm.com>
In-Reply-To: <51948AD4.3020104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 03:29 PM, Michael Wang wrote:
>> > Michael Wang had tested previous version on pgbench on his box:
>> > https://lkml.org/lkml/2013/4/2/1022
> Tested the latest patch set (new 3/8 and 6/8) with pgbench, tip
> 3.10.0-rc1 and 12 cpu X86 box, works well and still benefit ;-)


Thanks Michael! :)

-- 
Thanks
    Alex
