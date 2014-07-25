Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbaGYHf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:35:29 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47590 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGYHf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:35:28 -0400
Message-ID: <1406273721.5162.9.camel@marge.simpson.net>
Subject: Re: [LKP] [rcu] c0f489d2c6f: -1.5% netperf.Throughput_tps
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Date: Fri, 25 Jul 2014 09:35:21 +0200
In-Reply-To: <53D1FD0E.4080406@intel.com>
References: <53d1f486.t70cWJ/Ilm6Y3o5/%fengguang.wu@intel.com>
	 <53D1FD0E.4080406@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 14:45 +0800, Aaron Lu wrote: 
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit c0f489d2c6fec8994c642c2ec925eb858727dc7b ("rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs")
> 
> abaa93d9e1de2c2  c0f489d2c6fec8994c642c2ec  
> ---------------  -------------------------  
>      12654 ~ 0%      -1.5%      12470 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>      12654 ~ 0%      -1.5%      12470 ~ 0%  TOTAL netperf.Throughput_tps

Out of curiosity, what parameters do you use for this test?  In my
piddling around with high frequency switching loads, they tend to have
too much build to build and boot to boot variance to track 1.5%.

-Mike

