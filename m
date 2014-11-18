Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaKRK0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:26:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:50637 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbaKRK0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:26:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418065114"
Date: Tue, 18 Nov 2014 10:26:46 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com, dietmar.eggemann@arm.com,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH 0/3 v6] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20141118022646.GA4317@intel.com>
References: <1414711948-10475-1-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414711948-10475-1-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping...

On Fri, Oct 31, 2014 at 07:32:25AM +0800, Yuyang Du wrote:
> Many thanks to PeterZ for his review, to Dietmar, and to Fengguang for 0Day and LKP.
> 
> v6 changes:
> 
> Based on v3.18-rc2.
> 
> - Unify decay_load 32 and 64 bits by mul_u64_u32_shr
> - Add force option in update_tg_load_avg
> - Read real-time cfs's load_avg for calc_tg_weight
> - Have tg_load_avg_contrib ifdef CONFIG_FAIR_GROUP_SCHED
> - Bug fix
> 
