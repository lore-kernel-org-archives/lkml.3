Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaK3Ekx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 23:40:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54760 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaK3Ekv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 23:40:51 -0500
Date: Sat, 29 Nov 2014 20:45:03 -0800 (PST)
Message-Id: <20141129.204503.879046243709537472.davem@davemloft.net>
To: jasowang@redhat.com
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, vyasevic@redhat.com
Subject: Re: [PATCH net-next] macvlan: delay the header check for dodgy
 packets into lower device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416993674-11177-1-git-send-email-jasowang@redhat.com>
References: <1416993674-11177-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Nov 2014 20:40:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 26 Nov 2014 17:21:14 +0800

> We do header check twice for a dodgy packet. One is done before
> macvlan_start_xmit(), another is done before lower device's
> ndo_start_xmit(). The first one seems redundant so this patch tries to
> delay header check until a packet reaches its lower device (or macvtap)
> through always enabling NETIF_F_GSO_ROBUST for macvlan device.
> 
> Cc: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks.
