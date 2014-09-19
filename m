Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbaISU3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:29:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58942 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbaISU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:29:28 -0400
Date: Fri, 19 Sep 2014 16:29:26 -0400 (EDT)
Message-Id: <20140919.162926.1782273820747045814.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH 2/2] 3c59x: Fix bad offset spec in skb_frag_dma_map
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410959085-7351-2-git-send-email-nhorman@tuxdriver.com>
References: <alpine.LRH.2.11.1409160209280.21050@adalberg.ut.ee>
	<1410959085-7351-1-git-send-email-nhorman@tuxdriver.com>
	<1410959085-7351-2-git-send-email-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Sep 2014 13:29:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 17 Sep 2014 09:04:45 -0400

> Recently aded the use of skb_frag_dma_map to 3c59x, but didn't realize it
> automatically included the frag_offset internally, as well as provided an option
> to specify an extra offset in the parameter list.  We need to specify an offset
> of 0 in the parameter list to avoid skb corruption that results in lost
> connections.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Linux Kernel list <linux-kernel@vger.kernel.org>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Meelis Roos <mroos@linux.ee>
> Tested-by: Meelis Roos <mroos@linux.ee>

Applied.
