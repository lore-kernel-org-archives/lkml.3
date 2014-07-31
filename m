Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaGaI4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:56:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:51193 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250AbaGaI4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:56:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569858475"
Date: Thu, 31 Jul 2014 16:56:27 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731085626.GA23367@aaronlu.sh.intel.com>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140729081712.GS20603@laptop.programming.kicks-ass.net>
 <20140729160437.4561742f@annuminas.surriel.com>
 <20140730021425.GA25023@aaronlu.sh.intel.com>
 <20140731083330.GO19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731083330.GO19379@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 10:33:30AM +0200, Peter Zijlstra wrote:
> On Wed, Jul 30, 2014 at 10:14:25AM +0800, Aaron Lu wrote:
> > 118881 ~ 0%            +1.2%    120325 ~ 0% ivb42/hackbench/50%-threads-pipe
> 
> What kind of IVB is that EP or EX (or rather, how many sockets)? Also
> what arguments to hackbench do you use?
> 

2 sockets EP.

The cmdline is:
/usr/bin/hackbench -g 24 --threads --pipe -l 60000

Regards,
Aaron
