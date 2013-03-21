Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab3CUPtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:49:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43488 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab3CUPtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:49:02 -0400
Date: Thu, 21 Mar 2013 11:49:00 -0400 (EDT)
Message-Id: <20130321.114900.1573555053097095750.davem@davemloft.net>
To: lizefan@huawei.com
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: remove redundant ifdef CONFIG_CGROUPS
From: David Miller <davem@davemloft.net>
In-Reply-To: <514A767B.7000307@huawei.com>
References: <514A767B.7000307@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 21 Mar 2013 08:49:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>
Date: Thu, 21 Mar 2013 10:54:51 +0800

> The cgroup code has been surrounded by ifdef CONFIG_NET_CLS_CGROUP
> and CONFIG_NETPRIO_CGROUP.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied, thanks.
