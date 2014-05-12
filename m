Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaELSkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:40:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59734 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaELSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:39:59 -0400
Date: Mon, 12 May 2014 14:39:56 -0400 (EDT)
Message-Id: <20140512.143956.2213504439730586014.davem@davemloft.net>
To: dingtianhong@huawei.com
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oliver@neukum.org, stephen@networkplumber.org
Subject: Re: [PATCH net-next RESEND] vlan: rename __vlan_find_dev_deep() to
 __vlan_find_dev_deep_rcu_rcu()
From: David Miller <davem@davemloft.net>
In-Reply-To: <536C7C7D.1080603@huawei.com>
References: <536C7C7D.1080603@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 May 2014 11:39:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ding Tianhong <dingtianhong@huawei.com>
Date: Fri, 9 May 2014 14:58:05 +0800

> The __vlan_find_dev_deep should always called in RCU, according
> David's suggestion, rename to __vlan_find_dev_deep_rcu looks more
> reasonable.
> 
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>

Applied with subject corrected (too many "rcu"'s :-)

Thanks.
