Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3FGHaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:30:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:11064 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3FGHaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:30:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="325673024"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>
Subject: [RFC patch 0/4] change 64 bit variables to long type
Date: Fri,  7 Jun 2013 15:29:25 +0800
Message-Id: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some 64 bits variables in cfs_rq/tg etc. That ask expersive
operations in 32 bit machine. But in fact, long type is enough for them.

So do this change lead more efficient code and without data lose.

Regards
Alex

