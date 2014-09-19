Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbaISU3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:29:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765AbaISU3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:29:22 -0400
Date: Fri, 19 Sep 2014 16:29:19 -0400 (EDT)
Message-Id: <20140919.162919.2196253287493171915.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH 1/2] 3c59x: Add dma error checking and recovery
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410959085-7351-1-git-send-email-nhorman@tuxdriver.com>
References: <alpine.LRH.2.11.1409160209280.21050@adalberg.ut.ee>
	<1410959085-7351-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Sep 2014 13:29:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 17 Sep 2014 09:04:44 -0400

> Noted that 3c59x has no checks on transmit for failed DMA mappings, and no
> ability to unmap fragments when a single map fails in the middle of a transmit.
> This patch provides error checking to ensure that dma mappings work properly,
> and unrolls an skb mapping if a fragmented skb transmission has a mapping
> failure to prevent leaks.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Linux Kernel list <linux-kernel@vger.kernel.org>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Meelis Roos <mroos@linux.ee>
> Tested-by: Meelis Roos <mroos@linux.ee>

Applied.
