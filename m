Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3KBGQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 02:16:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34052 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3KBGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 02:16:53 -0400
Date: Sat, 02 Nov 2013 02:16:51 -0400 (EDT)
Message-Id: <20131102.021651.96548203258073968.davem@davemloft.net>
To: jasowang@redhat.com
Cc: edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmatouse@redhat.com, mst@redhat.com, dborkman@redhat.com
Subject: Re: [PATCH net] net: flow_dissector: fail on evil iph->ihl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383289270-18952-1-git-send-email-jasowang@redhat.com>
References: <1383289270-18952-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 01 Nov 2013 23:16:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri,  1 Nov 2013 15:01:10 +0800

> We don't validate iph->ihl which may lead a dead loop if we meet a IPIP
> skb whose iph->ihl is zero. Fix this by failing immediately when iph->ihl
> is evil (less than 5).
> 
> This issue were introduced by commit ec5efe7946280d1e84603389a1030ccec0a767ae
> (rps: support IPIP encapsulation).
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Petr Matousek <pmatouse@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable, thanks Jason.
