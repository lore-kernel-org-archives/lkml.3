Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LJB60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:58:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45009 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3LJB6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:58:24 -0500
Date: Mon, 09 Dec 2013 20:58:22 -0500 (EST)
Message-Id: <20131209.205822.126859687683341998.davem@davemloft.net>
To: joe@perches.com
Cc: mareklindner@neomailbox.ch, sw@simonwunderlich.de, antonio@meshcoding.com,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] etherdevice: Add ether_addr_equal_unaligned
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386368461.31845.38.camel@joe-AO722>
References: <1386364621.31845.32.camel@joe-AO722>
	<20131206.163806.1555069105347405484.davem@davemloft.net>
	<1386368461.31845.38.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 09 Dec 2013 17:58:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 06 Dec 2013 14:21:01 -0800

> Add a generic routine to test if possibly unaligned
> to u16 Ethernet addresses are equal.
> 
> If CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set,
> this uses the slightly faster generic routine
> ether_addr_equal, otherwise this uses memcmp.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
