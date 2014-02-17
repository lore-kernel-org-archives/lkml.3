Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaBQBA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:00:56 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:65448 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaBQBAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:00:54 -0500
Message-ID: <53015F3F.30409@huawei.com>
Date: Mon, 17 Feb 2014 09:00:47 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] bonding cleaning
References: <cover.1392508410.git.joe@perches.com>
In-Reply-To: <cover.1392508410.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/16 7:57, Joe Perches wrote:
> Miscellaneous cleanups
> 
> Joe Perches (4):
>   bonding: Convert pr_warning to pr_warn, neatening
>   bonding: Neaten pr_<level>
>   bonding: Convert c99 comments
>   bonding: Convert memcpy(foo, bar, ETH_ALEN) to ether_addr_copy(foo, bar)
> 
>  drivers/net/bonding/bond_3ad.c     |  19 +--
>  drivers/net/bonding/bond_3ad.h     | 175 ++++++++++++++--------------
>  drivers/net/bonding/bond_alb.c     |  36 +++---
>  drivers/net/bonding/bond_debugfs.c |  10 +-
>  drivers/net/bonding/bond_main.c    | 231 ++++++++++++++++++-------------------
>  drivers/net/bonding/bond_netlink.c |   6 +-
>  drivers/net/bonding/bond_options.c | 102 ++++++++--------
>  drivers/net/bonding/bond_procfs.c  |   8 +-
>  drivers/net/bonding/bond_sysfs.c   |   8 +-
>  9 files changed, 288 insertions(+), 307 deletions(-)
> 

Reviewed-by: Ding Tianhong <dingtianhong@huawei.com>

