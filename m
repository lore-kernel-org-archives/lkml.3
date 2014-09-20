Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbaITBTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 21:19:52 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57631 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaITBTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 21:19:51 -0400
Date: Fri, 19 Sep 2014 21:19:21 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH 1/2] 3c59x: Add dma error checking and recovery
Message-ID: <20140920011921.GA7586@localhost.localdomain>
References: <alpine.LRH.2.11.1409160209280.21050@adalberg.ut.ee>
 <1410959085-7351-1-git-send-email-nhorman@tuxdriver.com>
 <20140919.162919.2196253287493171915.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919.162919.2196253287493171915.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:29:19PM -0400, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Wed, 17 Sep 2014 09:04:44 -0400
> 
> > Noted that 3c59x has no checks on transmit for failed DMA mappings, and no
> > ability to unmap fragments when a single map fails in the middle of a transmit.
> > This patch provides error checking to ensure that dma mappings work properly,
> > and unrolls an skb mapping if a fragmented skb transmission has a mapping
> > failure to prevent leaks.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Linux Kernel list <linux-kernel@vger.kernel.org>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Meelis Roos <mroos@linux.ee>
> > Tested-by: Meelis Roos <mroos@linux.ee>
> 
> Applied.
> 
Thanks Dave!
Neil

