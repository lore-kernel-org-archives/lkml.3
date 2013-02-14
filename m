Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3BNOIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:08:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:54260 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544Ab3BNOIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:08:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,665,1355126400"; 
   d="scan'208";a="256947571"
Message-ID: <511CEFDD.9080709@intel.com>
Date: Thu, 14 Feb 2013 22:08:29 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 05/18] sched: quicker balancing on fork/exec/wake
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <1358996820-23036-6-git-send-email-alex.shi@intel.com> <1360664565.4485.13.camel@laptop> <511C9C54.4090508@linux.vnet.ibm.com>
In-Reply-To: <511C9C54.4090508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 04:12 PM, Preeti U Murthy wrote:
> **************************START PATCH*************************************
> 
> sched:Improve balancing for fork/exec/wake tasks

Can you test the patch with hackbench and aim7 with 2000 threads? plus
the patch in the tip:core/locking tree:

  3a15e0e0cdda rwsem: Implement writer lock-stealing for better scalability

If it works you may find some improvement.

-- 
Thanks
    Alex
