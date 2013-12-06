Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162360Ab3LFOKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:10:10 -0500
Received: from oker.escape.de ([194.120.234.254]:58191 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161297Ab3LFOKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:10:06 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2013 09:10:05 EST
Date: Fri, 6 Dec 2013 14:58:04 +0100
From: Jochen Striepe <jochen@tolot.escape.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20131206135804.GI2208@pompeji.miese-zwerge.org>
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130914112834.GM1509@pompeji.miese-zwerge.org>
 <20130923164931.GC2322@pompeji.miese-zwerge.org>
 <20131206002614.GD15492@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206002614.GD15492@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi again,

On Thu, Dec 05, 2013 at 04:26:14PM -0800, Paul E. McKenney wrote:
> Hmmm...  Does the following patch help?
[...]
> rcu: Kick CPU halfway to RCU CPU stall warning

The stall didn't appear at all since my last email, running 3.12.x
kernels since release. But I will test your patch later today. I assume
applying on top of 3.12.3 is correct?

Best greetings,
Jochen.
