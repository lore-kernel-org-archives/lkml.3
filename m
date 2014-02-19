Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaBSUib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:38:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbaBSUia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:38:30 -0500
Date: Wed, 19 Feb 2014 15:38:23 -0500 (EST)
Message-Id: <20140219.153823.2104782869234968037.davem@redhat.com>
To: dingtianhong@huawei.com
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] bonding: More ether_addr_copy and
 neatenings.
From: David Miller <davem@redhat.com>
In-Reply-To: <53040C96.2020600@huawei.com>
References: <cover.1392745013.git.joe@perches.com>
	<53040C96.2020600@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ding Tianhong <dingtianhong@huawei.com>
Date: Wed, 19 Feb 2014 09:44:54 +0800

> On 2014/2/19 1:42, Joe Perches wrote:
>> Joe Perches (3):
>>   bonding: More use of ether_addr_copy
>>   bonding: Remove unnecessary else
>>   bonding: Invert test
>> 
>>  drivers/net/bonding/bond_3ad.c  | 21 ++++++++++-----------
>>  drivers/net/bonding/bond_alb.c  | 17 ++++++++---------
>>  drivers/net/bonding/bond_main.c |  6 +++---
>>  3 files changed, 21 insertions(+), 23 deletions(-)
>> 
> 
> Reviewed-by: Ding Tianhong <dingtianhong@huawei.com>

Series applied, thanks Joe.
