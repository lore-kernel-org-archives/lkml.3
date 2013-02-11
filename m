Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3BKJK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:10:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:13199 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab3BKJK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:10:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,641,1355126400"; 
   d="scan'208";a="285624999"
Date: Mon, 11 Feb 2013 17:10:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [flow_cache_new_hashrnd] WARNING: at kernel/smp.c:328
 smp_call_function_single()
Message-ID: <20130211091046.GA12094@localhost>
References: <20130211085600.GB10857@localhost>
 <20130211090309.GA23932@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211090309.GA23932@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 10:03:09AM +0100, Ingo Molnar wrote:
> 
> * Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > Greetings,
> > 
> > I got the below oops and the first bad commit is
> 
> It's a one-time warning, not an actual crash, right?

Yes, it is.

Thanks,
Fengguang
