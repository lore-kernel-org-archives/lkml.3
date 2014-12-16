Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaLPQU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:20:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53393 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaLPQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:20:26 -0500
Date: Tue, 16 Dec 2014 11:20:21 -0500 (EST)
Message-Id: <20141216.112021.1488501911448698827.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com, jasowang@redhat.com
Subject: Re: [PATCH 0/5] tun/macvtap: TUNSETIFF fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418732988-3535-1-git-send-email-mst@redhat.com>
References: <1418732988-3535-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Dec 2014 08:20:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 16 Dec 2014 15:04:53 +0200

> Dan Carpenter reported the following:
 ...
> And that's true: we have run out of IFF flags in tun.
> 
> So let's not try to add more: add simple GET/SET ioctls
> instead. Easy to test, leads to clear semantics.
> 
> Alternatively we'll have to revert the whole thing for 3.19,
> but that seems more work as this has dependencies
> in other places.
> 
> While here, I noticed that macvtap was actually reading
> ifreq flags as a 32 bit field.
> Fix that up as well.

Looks good, series applied, thanks.
