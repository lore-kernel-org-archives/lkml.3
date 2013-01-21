Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3AUEQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:16:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33623 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3AUEQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:16:31 -0500
Date: Sun, 20 Jan 2013 23:16:30 -0500 (EST)
Message-Id: <20130120.231630.1756371720847819355.davem@davemloft.net>
To: yoshfuji@linux-ipv6.org
Cc: linux1394-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire net: Ensure checksumming in upper layer.
From: David Miller <davem@davemloft.net>
In-Reply-To: <50FBA02C.9030203@linux-ipv6.org>
References: <50FBA02C.9030203@linux-ipv6.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Date: Sun, 20 Jan 2013 16:43:40 +0900

> It is wrong to set skb->ip_summed to CHECKSUM_UNNECESSARY unless
> the device has already checked it.
> 
> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Applied.
