Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3K1Xc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 18:32:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47416 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3K1Xcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 18:32:54 -0500
Date: Thu, 28 Nov 2013 18:32:52 -0500 (EST)
Message-Id: <20131128.183252.1826466962938354277.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        vyasevic@redhat.com, edumazet@google.com
Subject: Re: [PATCH net] macvtap: fix tx_dropped counting error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385371144-11071-1-git-send-email-jasowang@redhat.com>
References: <1385371144-11071-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Nov 2013 15:32:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 25 Nov 2013 17:19:04 +0800

> After commit 8ffab51b3dfc54876f145f15b351c41f3f703195
> (macvlan: lockless tx path), tx stat counter were converted to percpu stat
> structure. So we need use to this also for tx_dropped in macvtap. Otherwise, the
> management won't notice the dropping packet in macvtap tx path.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Vlad Yasevich <vyasevic@redhat.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks Jason.
