Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab3A1B1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 20:27:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:54316 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab3A1B1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 20:27:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,548,1355126400"; 
   d="scan'208";a="195679911"
Message-ID: <5105D442.9090401@intel.com>
Date: Mon, 28 Jan 2013 09:28:34 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 11:06 AM, Alex Shi wrote:
> Since the runnable info needs 345ms to accumulate, balancing
> doesn't do well for many tasks burst waking. After talking with Mike
> Galbraith, we are agree to just use runnable avg in power friendly 
> scheduling and keep current instant load in performance scheduling for 
> low latency.
> 
> So the biggest change in this version is removing runnable load avg in
> balance and just using runnable data in power balance.
> 
> The patchset bases on Linus' tree, includes 3 parts,

Would you like to give some comments, Ingo? :)

Best regards!


