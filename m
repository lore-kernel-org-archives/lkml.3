Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaELJds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:33:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:23778 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbaELJdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:33:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="510166699"
Date: Mon, 12 May 2014 09:28:57 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com
Subject: Re: [RFC PATCH 00/12 v2] A new CPU load metric for power-efficient
 scheduler: CPU ConCurrency
Message-ID: <20140512012856.GA9351@intel.com>
References: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
 <20140512064533.GH30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512064533.GH30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 08:45:33AM +0200, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 02:16:49AM +0800, Yuyang Du wrote:
> 
> Yes, just what we need, more patches while we haven't had the time to
> look at the old set yet :-(

No essential change, added commit messages (after smashing our heads to
figure out what general code structure is). Can we get over immediate no go to
maybe slow no go?

Thanks,
Yuyang
