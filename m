Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbaGNXOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 19:14:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36635 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbaGNXOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 19:14:36 -0400
Date: Mon, 14 Jul 2014 16:14:35 -0700 (PDT)
Message-Id: <20140714.161435.909932787419949578.davem@davemloft.net>
To: jasowang@redhat.com
Cc: amirv@mellanox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] mlx4: mark napi id for gro_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405309364-32258-1-git-send-email-jasowang@redhat.com>
References: <1405309364-32258-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Jul 2014 16:14:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 14 Jul 2014 11:42:44 +0800

> Napi id was not marked for gro_skb, this will lead rx busy loop won't
> work correctly since they stack never try to call low latency receive
> method because of a zero socket napi id. Fix this by marking napi id
> for gro_skb.
> 
> The transaction rate of 1 byte netperf tcp_rr gets about 50% increased
> (from 20531.68 to 30610.88).
> 
> Cc: Amir Vadai <amirv@mellanox.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks.
