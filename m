Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab3CQS37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:29:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46864 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3CQS36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:29:58 -0400
Date: Sun, 17 Mar 2013 14:29:55 -0400 (EDT)
Message-Id: <20130317.142955.1114572401286297685.davem@davemloft.net>
To: mst@redhat.com
Cc: stable@kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        basil.gor@gmail.com, nab@risingtidesystems.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] vhost/net: fix heads usage of ubuf_info
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130317124609.GA25967@redhat.com>
References: <20130317124609.GA25967@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 17 Mar 2013 11:30:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 17 Mar 2013 14:46:09 +0200

> ubuf info allocator uses guest controlled head as an index,
> so a malicious guest could put the same head entry in the ring twice,
> and we will get two callbacks on the same value.
> To fix use upend_idx which is guaranteed to be unique.
> 
> Reported-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied and queued up for -stable, thanks.

And thankfully you got the stable URL wrong, please do not CC:
networking patches to stable, just make sure I apply them and in
your post-commit text explicitly ask me to queue it up to my
-stable queue.

Thanks.

