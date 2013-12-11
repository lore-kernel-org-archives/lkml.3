Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3LKDTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:19:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53977 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3LKDTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:19:14 -0500
Date: Tue, 10 Dec 2013 22:19:12 -0500 (EST)
Message-Id: <20131210.221912.1575828670029427023.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: jasowang@redhat.com, mst@redhat.com, vyasevich@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tun: remove useless codes in tun_chr_aio_read()
 and tun_recvmsg()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAEH94Li+9tNP_U-og7oSyez4stqUTJ6xGCPaCmTSkyNZsRTT7w@mail.gmail.com>
References: <52A74CD1.808@gmail.com>
	<20131210.140036.1328560146971385473.davem@davemloft.net>
	<CAEH94Li+9tNP_U-og7oSyez4stqUTJ6xGCPaCmTSkyNZsRTT7w@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 19:19:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Wed, 11 Dec 2013 11:14:04 +0800

> Only one reminder, since David has committed the two patches, you
> maybe need to take their impact on your patches into account.

I reverted these changes from net-next.
