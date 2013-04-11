Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3DKUW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:22:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38959 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3DKUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:22:26 -0400
Date: Thu, 11 Apr 2013 16:22:24 -0400 (EDT)
Message-Id: <20130411.162224.1462196338243001372.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 0/2] vlan TSO support for virtio-net
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365672742-42258-1-git-send-email-jasowang@redhat.com>
References: <1365672742-42258-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 13:22:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 11 Apr 2013 17:32:20 +0800

> This series simply enable the vlan TSO support for virtio-net by just initialize
> vlan_features for virtio-net and tun which allows vlan TSO packets to be
> processed in both TX and RX path for virtio-net.
> 
> Netperf shows great improvements on stream tests:

Both applied to net-next, thanks.
