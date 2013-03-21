Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3CURly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:41:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:45292 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3CURlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:41:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,887,1355126400"; 
   d="scan'208";a="282843612"
Message-ID: <514B464A.50700@linux.intel.com>
Date: Thu, 21 Mar 2013 10:41:30 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com> <1363636794.15703.32@driftwood> <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com> <20130318222548.GG3656@linux.vnet.ibm.com> <1363822338.6345.33.camel@gandalf.local.home> <20130320235545.GL3637@linux.vnet.ibm.com> <1363825631.6345.45.camel@gandalf.local.home> <514B2B03.4030301@linux.intel.com> <20130321171806.GX3637@linux.vnet.ibm.com>
In-Reply-To: <20130321171806.GX3637@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/2013 10:18 AM, Paul E. McKenney wrote:
> 	o	Use the "idle=poll" boot parameter.  However, please note
> 		that use of this parameter can cause your CPU to overheat,
> 		which may cause thermal throttling to degrade your
> 		latencies --and that this degradation can be even worse
> 		than that of dyntick-idle.

it also disables (effectively) Turbo Mode on Intel cpus... which can cost you a serious percentage of performance
