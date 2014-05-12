Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaEMDjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:39:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:33257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbaEMDjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:39:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1040,1389772800"; 
   d="scan'208";a="510664721"
Date: Tue, 13 May 2014 03:34:53 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Smythies <dsmythies@telus.net>
Subject: Re: [RFC PATCH] cpufreq: intel_pstate: Change the calculation of
 next pstate
Message-ID: <20140512193453.GB9351@intel.com>
References: <5368255D.3090207@semaphore.gr>
 <536BEE89.3040602@gmail.com>
 <536CECB4.1090109@semaphore.gr>
 <53712F4B.7000101@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53712F4B.7000101@semaphore.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:30:03PM +0300, Stratos Karafotis wrote:
> On 09/05/2014 05:56 μμ, Stratos Karafotis wrote:
>
> Next performance state = min_perf + (max_perf - min_perf) * load / 100
> 
Hi,

This formula is fundamentally broken. You need to associate the load with its
frequency.

Thanks,
Yuyang
