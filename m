Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaJVBgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:36:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54034 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaJVBgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:36:08 -0400
Date: Tue, 21 Oct 2014 21:36:04 -0400 (EDT)
Message-Id: <20141021.213604.498626106621926349.davem@davemloft.net>
To: tgraf@suug.ch
Cc: davem@davemloft.ne, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] netlink: Re-add locking to netlink_lookup() and seq
 walker
From: David Miller <davem@davemloft.net>
In-Reply-To: <14101d52c64e0d52176ca0d4b8888f8cf20ab9b0.1413921873.git.tgraf@suug.ch>
References: <14101d52c64e0d52176ca0d4b8888f8cf20ab9b0.1413921873.git.tgraf@suug.ch>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Oct 2014 18:36:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Tue, 21 Oct 2014 22:05:38 +0200

> The synchronize_rcu() in netlink_release() introduces unacceptable
> latency. Reintroduce minimal lookup so we can drop the
> synchronize_rcu() until socket destruction has been RCUfied.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: Steinar H. Gunderson <sgunderson@bigfoot.com>
> Reported-and-tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Thomas Graf <tgraf@suug.ch>

Applied and queued up for -stable.

Please use an appropriate "Fixes: " tag in the future, this is
especially important for an issue as serious as this one.

Thanks.
