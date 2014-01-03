Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaACAX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:23:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54725 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaACAX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:23:56 -0500
Date: Thu, 02 Jan 2014 19:23:54 -0500 (EST)
Message-Id: <20140102.192354.1248162707820922093.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.shah@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net] virtio-net: fix refill races during restore
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388374480-3872-1-git-send-email-jasowang@redhat.com>
References: <1388374480-3872-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 Jan 2014 16:23:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 30 Dec 2013 11:34:40 +0800

> During restoring, try_fill_recv() was called with neither napi lock nor napi
> disabled. This can lead two try_fill_recv() was called in the same time. Fix
> this by refilling before trying to enable napi.
> 
> Fixes 0741bcb5584f9e2390ae6261573c4de8314999f2
> (virtio: net: Add freeze, restore handlers to support S4).
> 
> Cc: Amit Shah <amit.shah@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable, thanks.
