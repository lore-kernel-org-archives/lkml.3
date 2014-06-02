Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaFBVDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:03:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36763 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaFBVDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:03:13 -0400
Date: Mon, 02 Jun 2014 14:03:12 -0700 (PDT)
Message-Id: <20140602.140312.98558447285279661.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, mimu@linux.vnet.ibm.com, romain@orebokech.com
Subject: Re: [PULL net-next] vhost enhancements for 3.16
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140602205515.GA10287@redhat.com>
References: <20140602205515.GA10287@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 14:03:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 2 Jun 2014 23:55:15 +0300

> The following changes since commit 96b2e73c5471542cb9c622c4360716684f8797ed:
> 
>   Revert "net/mlx4_en: Use affinity hint" (2014-06-02 00:18:48 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-next
> 
> for you to fetch changes up to 2ae76693b8bcabf370b981cd00c36cd41d33fabc:
> 
>   vhost: replace rcu with mutex (2014-06-02 23:47:59 +0300)

Can you please post the actual patches as part of your pull request just
like the other maintainers do?

Thanks.
