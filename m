Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753Ab3DCIRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:17:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:26671 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760653Ab3DCIRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="288645431"
Message-ID: <515BE597.20901@intel.com>
Date: Wed, 03 Apr 2013 16:17:27 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v6 0/21] sched: power aware scheduling
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 10:34 PM, Alex Shi wrote:
> This patch set implement/consummate the rough power aware scheduling
> proposal: https://lkml.org/lkml/2012/8/13/139.
> 
> The code also on this git tree:
> https://github.com/alexshi/power-scheduling.git power-scheduling

Many many thanks for PJT, Vincent, Preeti, Namhyung and Michael Wang's
testing and suggestions!

patch set were updated in above git tree.
Few quick testing show the new code has slight better performance on
aim7/hackbench with powersaving policy while keep the task packing
behaviour.
Thanks all!
> 
