Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab3FJHGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:06:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3FJHGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:06:46 -0400
Date: Mon, 10 Jun 2013 10:07:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
Message-ID: <20130610070710.GA673@redhat.com>
References: <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk>
 <1360207111.28557.47.camel@edumazet-glaptop>
 <1360254046.3605.8.camel@bwh-desktop.uk.solarflarecom.com>
 <20130207.131420.1211188723341167971.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207.131420.1211188723341167971.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 01:14:20PM -0500, David Miller wrote:
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Thu, 7 Feb 2013 16:20:46 +0000
> 
> > If the consensus is still that we must preserve packets exactly (aside
> > from the usual modifications by IP routers) then LRO should be disabled
> > on all devices for which forwarding is enabled.
> 
> I believe this is still undoubtedly the consensus.

With virtio we are getting packets from a linux host,
so we could thinkably preserve packets exactly
even with LRO. I am guessing other hardware could be
doing this as well.

I am not sure what information would need to be preserved -
could someone help clarify please?

-- 
MST
