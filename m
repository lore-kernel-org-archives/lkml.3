Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaBSBpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:45:04 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:7002 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaBSBpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:45:01 -0500
Message-ID: <53040C96.2020600@huawei.com>
Date: Wed, 19 Feb 2014 09:44:54 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] bonding: More ether_addr_copy and neatenings.
References: <cover.1392745013.git.joe@perches.com>
In-Reply-To: <cover.1392745013.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/19 1:42, Joe Perches wrote:
> Joe Perches (3):
>   bonding: More use of ether_addr_copy
>   bonding: Remove unnecessary else
>   bonding: Invert test
> 
>  drivers/net/bonding/bond_3ad.c  | 21 ++++++++++-----------
>  drivers/net/bonding/bond_alb.c  | 17 ++++++++---------
>  drivers/net/bonding/bond_main.c |  6 +++---
>  3 files changed, 21 insertions(+), 23 deletions(-)
> 

Reviewed-by: Ding Tianhong <dingtianhong@huawei.com>

