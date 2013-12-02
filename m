Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3LBWRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:17:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54947 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3LBWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:16:56 -0500
Date: Mon, 02 Dec 2013 17:16:54 -0500 (EST)
Message-Id: <20131202.171654.1682815174948392171.davem@davemloft.net>
To: kamala@aristanetworks.com
Cc: hannes@stressinduktion.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4] IPv6: Fixed support for blackhole and prohibit
 routes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385994322-23117-1-git-send-email-kamala@aristanetworks.com>
References: <1385994322-23117-1-git-send-email-kamala@aristanetworks.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 02 Dec 2013 14:16:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamala R <kamala@aristanetworks.com>
Date: Mon,  2 Dec 2013 19:55:21 +0530

> The behaviour of blackhole and prohibit routes has been corrected by setting
> the input and output pointers of the dst variable appropriately. For
> blackhole routes, they are set to dst_discard and to ip6_pkt_discard and
> ip6_pkt_discard_out respectively for prohibit routes.
> 
> ipv6: ip6_pkt_prohibit(_out) should not depend on
> CONFIG_IPV6_MULTIPLE_TABLES
> 
> We need ip6_pkt_prohibit(_out) available without
> CONFIG_IPV6_MULTIPLE_TABLES
> 
> Signed-off-by: Kamala R <kamala@aristanetworks.com>

Applied and queued up for -stable, thanks.
