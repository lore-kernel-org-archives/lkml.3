Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3BKBPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 20:15:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60547 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3BKBPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 20:15:32 -0500
Date: Sun, 10 Feb 2013 20:15:28 -0500 (EST)
Message-Id: <20130210.201528.104811532648035805.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: mst@redhat.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
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
In-Reply-To: <1360276295.3605.44.camel@bwh-desktop.uk.solarflarecom.com>
References: <20130207.131420.1211188723341167971.davem@davemloft.net>
	<20130207213315.GB5064@redhat.com>
	<1360276295.3605.44.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 7 Feb 2013 22:31:35 +0000

> On Thu, 2013-02-07 at 23:33 +0200, Michael S. Tsirkin wrote:
>> We might want to add code to forward LRO status from macvlan
>> (not macvtap) back to the lowerdev, so that setting up forwarding
>> from macvlan disables LRO on the lowerdev, but that seems like another
>> issue.
> 
> I think it's the same issue!

I do too, can someome please work to resolve this properly?

Thanks.
