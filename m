Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3DLHIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 03:08:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44173 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3DLHIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 03:08:10 -0400
Date: Fri, 12 Apr 2013 03:08:07 -0400 (EDT)
Message-Id: <20130412.030807.2228977831606614404.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130412160018.3d54c801f40fbc13058ded07@canb.auug.org.au>
References: <20130412160018.3d54c801f40fbc13058ded07@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 12 Apr 2013 00:08:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Apr 2013 16:00:18 +1000

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> net/core/netprio_cgroup.c:250:29: error: static declaration of 'net_prio_subsys' follows non-static declaration
> include/linux/cgroup_subsys.h:71:1: note: previous declaration of 'net_prio_subsys' was here
> 
> Caused by commit 763eff57de89 ("netprio_cgroup: make local table static")
> from the net-next tree.
> 
> I have reverted that commit for today.

I've reverted it from net-next too, thanks Stephen.

> /me hates macros that construct symbols ...

/me hates automatic checkers that don't expand macros :-)
