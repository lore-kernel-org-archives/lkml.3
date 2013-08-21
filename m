Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3HUSPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:15:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34393 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3HUSPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:15:05 -0400
Date: Wed, 21 Aug 2013 11:15:00 -0700 (PDT)
Message-Id: <20130821.111500.578777610906041340.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingtianhong@huawei.com
Subject: Re: linux-next: build warning after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130821191041.712893827d8000c6dca8781b@canb.auug.org.au>
References: <20130821191041.712893827d8000c6dca8781b@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 21 Aug 2013 11:15:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 21 Aug 2013 19:10:41 +1000

> Hi all,
> 
> After merging the net-next tree, today's linux-next build (i386 defconfig
> and probably others) produced this warning:
> 
> net/ipv6/addrconf.c: In function 'addrconf_notify':
> net/ipv6/addrconf.c:2793:22: warning: 'link_dev' may be used uninitialized in this function [-Wuninitialized]
> net/ipv6/addrconf.c:2802:21: note: 'link_dev' was declared here
> 
> Introduced by commit df8372ca747f ("ipv6: fix checkpatch errors in
> net/ipv6/addrconf.c").  It looks like here are some missing braces.

Yes, which has since been reverted.
