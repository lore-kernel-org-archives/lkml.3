Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3FMHqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:46:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37180 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab3FMHqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:46:10 -0400
Date: Thu, 13 Jun 2013 00:46:07 -0700 (PDT)
Message-Id: <20130613.004607.546745883080814853.davem@davemloft.net>
To: gaofeng@cn.fujitsu.com
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: make compare exist all the time
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371089138-4990-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <20130613012216.GA6788@localhost>
	<1371089138-4990-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gao feng <gaofeng@cn.fujitsu.com>
Date: Thu, 13 Jun 2013 10:05:38 +0800

> Commit da12c90e099789a63073fc82a19542ce54d4efb9
> "netlink: Add compare function for netlink_table"
> only set compare at the time we create kernel netlink,
> and reset compare to NULL at the time we finially
> release netlink socket, but netlink_lookup wants
> the compare exist always.
> 
> So we should set compare after we allocate nl_table,
> and never reset it. make comapre exist all the time.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

Applied, thanks.
