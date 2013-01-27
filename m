Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3A0GYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:24:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55373 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3A0GYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:24:06 -0500
Date: Sun, 27 Jan 2013 01:24:04 -0500 (EST)
Message-Id: <20130127.012404.1641802338970836635.davem@davemloft.net>
To: gaowanlong@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        jasowang@redhat.com, erdnetdev@gmail.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH V8 2/3] virtio-net: split out clean affinity function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1359107491-6749-2-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1359107491-6749-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1359107491-6749-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Date: Fri, 25 Jan 2013 17:51:30 +0800

> Split out the clean affinity function to virtnet_clean_affinity().
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Eric Dumazet <erdnetdev@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied.
