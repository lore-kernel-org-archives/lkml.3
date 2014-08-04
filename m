Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaHDTrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:47:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45268 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHDTrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:47:07 -0400
Date: Mon, 04 Aug 2014 12:47:05 -0700 (PDT)
Message-Id: <20140804.124705.982661414906553098.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] bridge: remove a useless comment
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407158554-17384-1-git-send-email-mst@redhat.com>
References: <1407158554-17384-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 12:47:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 4 Aug 2014 15:22:40 +0200

> commit 6cbdceeb1cb12c7d620161925a8c3e81daadb2e4
>     bridge: Dump vlan information from a bridge port
> introduced a comment in an attempt to explain the
> code logic. The comment is unfinished so it confuses more
> than it explains, remove it.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks.
