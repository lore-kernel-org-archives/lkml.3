Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783Ab3IDCfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:35:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761622Ab3IDCfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:35:00 -0400
Date: Tue, 03 Sep 2013 22:34:59 -0400 (EDT)
Message-Id: <20130903.223459.300009956806963697.davem@davemloft.net>
To: joe@perches.com
Cc: acme@ghostprotocols.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] llc: Use normal etherdevice.h tests
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378066315.1953.23.camel@joe-AO722>
References: <1378066315.1953.23.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 03 Sep 2013 19:35:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 01 Sep 2013 13:11:55 -0700

> Convert the llc_<foo> static inlines to the
> equivalents from etherdevice.h and remove
> the llc_<foo> static inline functions.
> 
> llc_mac_null -> is_zero_ether_addr
> llc_mac_multicast -> is_multicast_ether_addr
> llc_mac_match -> ether_addr_equal
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
