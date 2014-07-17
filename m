Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaGQGVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:21:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57694 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaGQGVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:21:17 -0400
Date: Wed, 16 Jul 2014 23:21:16 -0700 (PDT)
Message-Id: <20140716.232116.802194909968085691.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2 0/3] rx busy polling support for virtio-net 
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405491707-22706-1-git-send-email-jasowang@redhat.com>
References: <1405491707-22706-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Jul 2014 23:21:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 16 Jul 2014 14:21:44 +0800

> Hi all:
> 
> This series introduces the support for rx busy polling support. This
> was useful for reduing the latency for a kvm guest. Patch 1-2
> introduces helpers which is used for rx busy polling. Patch 3
> implement the main function.
> 
> Test was done between a kvm guest and an external host. Two hosts were
> connected through 40gb mlx4 cards. With both busy_poll and busy_read are
> set to 50 in guest, 1 byte netperf tcp_rr shows 116% improvement:
> transaction rate was increased from 9151.94 to 19787.37.
> 
> Changes from V1:
> - split the patch info smaller ones
> - add more details about test setup/configuration
> 
> Please review.

Looks like you can make some minor adjustments based upon review, and
anyways I'd like to wait for Michael to get back and review a change
of this nature.

Thanks.
