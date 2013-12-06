Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161113Ab3LFUar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:30:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42226 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab3LFUaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:30:46 -0500
Date: Fri, 06 Dec 2013 15:30:44 -0500 (EST)
Message-Id: <20131206.153044.1353870753889298332.davem@davemloft.net>
To: avagin@openvz.org
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mwdalton@google.com, rusty@rustcorp.com.au,
        mst@redhat.com
Subject: Re: [PATCH 1/2] virtio-net: determine type of bufs correctly
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386254181-17257-2-git-send-email-avagin@openvz.org>
References: <1386254181-17257-1-git-send-email-avagin@openvz.org>
	<1386254181-17257-2-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 12:30:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Thu,  5 Dec 2013 18:36:20 +0400

> free_unused_bufs must check vi->mergeable_rx_bufs before
> vi->big_packets, because we use this sequence in other places.
> Otherwise we allocate buffer of one type, then free it as another
> type.
 ...
> Fixes: 2613af0ed18a (virtio_net: migrate mergeable rx buffers to page frag allocators)
> Cc: Michael Dalton <mwdalton@google.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied.
