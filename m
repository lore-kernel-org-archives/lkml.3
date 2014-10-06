Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaJFTCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:02:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37053 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaJFTCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:02:42 -0400
Date: Mon, 06 Oct 2014 15:02:38 -0400 (EDT)
Message-Id: <20141006.150238.2180269239953265506.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/16] virtio_net: drop config_enable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412525038-15871-9-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-9-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Oct 2014 12:02:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 5 Oct 2014 19:07:13 +0300

> Now that virtio core ensures config changes don't arrive during probing,
> drop config_enable flag in virtio net.
> On removal, flush is now sufficient to guarantee that no change work is
> queued.
> 
> This help simplify the driver, and will allow setting DRIVER_OK earlier
> without losing config change notifications.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

It's hard for people on the networking side to review these changes
since you haven't CC:'d them on any of the postings necessary to
understand the context of the net/ and drivers/net/ changes.

Please at a minimum CC: everyone on your header [PATCH 0/N] posting
so we know at least at a high level what is going on, and why.

Thanks.
