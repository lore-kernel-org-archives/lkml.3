Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab3FNAnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 20:43:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48270 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3FNAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 20:43:40 -0400
Date: Thu, 13 Jun 2013 17:43:39 -0700 (PDT)
Message-Id: <20130613.174339.1937633112098047039.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        erdnetdev@gmail.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, alexr@mellanox.com, avnerb@mellanox.com,
        ork@mellanox.com, sockperf-dev@googlegroups.com, eliezer@tamir.org.il
Subject: Re: [PATCH v3 net-next 0/4] net: low latency sockets follow ups
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130613144613.4875.46858.stgit@ladj378.jer.intel.com>
References: <20130613144613.4875.46858.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Thu, 13 Jun 2013 17:46:13 +0300

> Here are three clean up patches, plus one that adds a socket option for LLS.
> 
> Patch 1 converts low latency sockets to sched_clock.
> Patch 2 removes the config menu for NET_LL_RX_POLL and defaults to y.
> Patch 3 converts sysctl_net_ll_poll into an unsigned int
> Patch 4 adds an SO_LL socket option to allow per-socket control of busy polling.
> 
> I will reply to this thread with a patch to sockperf that enables
> the socket option. (unchanged from v2)
> 
> Again, thanks to everyone for their comments.

Please respin with the overflow introduced by patch #3 corrected, everything
else looks fine to me.
