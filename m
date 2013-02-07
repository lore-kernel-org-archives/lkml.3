Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab3BGSO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:14:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52817 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab3BGSO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:14:26 -0500
Date: Thu, 07 Feb 2013 13:14:20 -0500 (EST)
Message-Id: <20130207.131420.1211188723341167971.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        eilong@broadcom.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, peter.p.waskiewicz.jr@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        tushar.n.dave@intel.com, jitendra.kalsaria@qlogic.com,
        sony.chacko@qlogic.com, linux-driver@qlogic.com,
        john.r.fastabend@intel.com, jacob.e.keller@intel.com,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360254046.3605.8.camel@bwh-desktop.uk.solarflarecom.com>
References: <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk>
	<1360207111.28557.47.camel@edumazet-glaptop>
	<1360254046.3605.8.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 7 Feb 2013 16:20:46 +0000

> If the consensus is still that we must preserve packets exactly (aside
> from the usual modifications by IP routers) then LRO should be disabled
> on all devices for which forwarding is enabled.

I believe this is still undoubtedly the consensus.
