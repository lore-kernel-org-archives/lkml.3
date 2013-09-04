Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852Ab3IDCrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:47:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54031 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761644Ab3IDCro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:47:44 -0400
Date: Tue, 03 Sep 2013 22:47:41 -0400 (EDT)
Message-Id: <20130903.224741.300532243318088831.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/6] vhost code cleanup and minor enhancement
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378111261-14826-1-git-send-email-jasowang@redhat.com>
References: <1378111261-14826-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 03 Sep 2013 19:47:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon,  2 Sep 2013 16:40:55 +0800

> This series tries to unify and simplify vhost codes especially for
> zerocopy. With this series, 5% - 10% improvement for per cpu throughput were
> seen during netperf guest sending test.
> 
> Plase review.

Applied and patch #5 queued up for -stable, thanks.
