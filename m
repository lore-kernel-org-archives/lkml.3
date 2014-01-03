Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaACFeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:34:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56113 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaACFeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:34:07 -0500
Date: Fri, 03 Jan 2014 00:34:04 -0500 (EST)
Message-Id: <20140103.003404.1439874071277993396.davem@davemloft.net>
To: clbchenlibo.chen@huawei.com
Cc: edumazet@google.com, jasowang@redhat.com, horms@verge.net.au,
        serge.hallyn@ubuntu.com, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        kaber@trash.net, xemul@openvz.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, jhs@mojatatu.com, lizefan@huawei.com
Subject: Re: [RFC PATCH net-next 1/4] net: introduce backup_classid to
 struct skbuff
From: David Miller <davem@davemloft.net>
In-Reply-To: <52C62A48.1050604@huawei.com>
References: <52C62A48.1050604@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 Jan 2014 21:34:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <clbchenlibo.chen@huawei.com>
Date: Fri, 3 Jan 2014 11:11:04 +0800

> 
> introduce backup_classid to struct skbuff,
> we can use it to backup sk_classid when net_ns switch.
> 
> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>

Sorry, no new sk_buff members unless there is absolutely not other
possible implementation.

sk_buff is too big as-is.
