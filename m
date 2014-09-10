Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaIJTnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:43:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42815 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaIJTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:43:39 -0400
Date: Wed, 10 Sep 2014 12:43:35 -0700 (PDT)
Message-Id: <20140910.124335.837039370159482619.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, sage@inktank.com, ursula.braun@de.ibm.com,
        linux390@de.ibm.com, pablo@netfilter.org, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-s390@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next 0/5] net: Convert pr_warning to pr_warn
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1410322181.git.joe@perches.com>
References: <cover.1410322181.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Sep 2014 12:43:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue,  9 Sep 2014 21:17:27 -0700

> Remove remaining uses of pr_warning in net/
> 
> Joe Perches (5):
>   atm: Convert pr_warning to pr_warn
>   ceph: Convert pr_warning to pr_warn
>   pktgen: Convert pr_warning to pr_warn
>   iucv: Convert pr_warning to pr_warn
>   netfilter: Convert pr_warning to pr_warn

All except the ceph patch which is going via another tree.
