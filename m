Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3EFPIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:08:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3EFPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:08:03 -0400
Date: Mon, 06 May 2013 11:08:00 -0400 (EDT)
Message-Id: <20130506.110800.1388239604905052651.davem@davemloft.net>
To: brouer@redhat.com
Cc: khlebnikov@openvz.org, netdev@vger.kernel.org, edumazet@google.com,
        fw@strlen.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: frag, fix race conditions in LRU list maintenance
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130506093318.679f5557@redhat.com>
References: <20130505145622.9351.86587.stgit@zurg>
	<20130506093318.679f5557@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 May 2013 08:08:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 6 May 2013 09:33:18 +0200

> This a good fix, and better than my earlier attempt at fixing this.
 ...
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied, but this patch was generated against a very old tree,
one before the q->net->nqueues stuff was added.

I sorted out the conflicts but someone needs to double-check
my work.
