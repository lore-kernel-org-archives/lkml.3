Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3K3VKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 16:10:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3K3VKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 16:10:02 -0500
Date: Sat, 30 Nov 2013 16:10:00 -0500 (EST)
Message-Id: <20131130.161000.1050565138363035368.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonathan.davies@citrix.com,
        paul.durrant@citrix.com
Subject: Re: [PATCH net-next] xen-netback: Fix pull size in
 checksum_setup_ip*
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385751407-9365-1-git-send-email-zoltan.kiss@citrix.com>
References: <1385751407-9365-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 30 Nov 2013 13:10:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Fri, 29 Nov 2013 18:56:47 +0000

> Before checksum setup we need to make sure we have enough data in linear
> buffer, so we do a pull if not. The calculation of the required data counts
> with skb->network_header, which is the headroom size actually. This is not
> necessary, and can cause unreasonable pulling. I've also removed
> MAX_IPOPTLEN, as we only need the base header at that point.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

The net-next tree is no open, therefore it is not appropriate to submit
patches targetting to that tree at this time.

I will make an explicit announcement on netdev when I have openned
the net-next tree, so it will be clear exactly when you can submit
patches targetting that tree again.

Thank you.
