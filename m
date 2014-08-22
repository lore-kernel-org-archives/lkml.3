Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaHVT2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:28:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaHVT2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:28:11 -0400
Date: Fri, 22 Aug 2014 12:28:10 -0700 (PDT)
Message-Id: <20140822.122810.1637401319817927091.davem@davemloft.net>
To: bernat.ada@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] net/ipv4/igmp.c: Replace rcu_dereference() with
 rcu_access_pointer()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140817124941.GA14000@ada>
References: <20140817124941.GA14000@ada>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 12:28:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Date: Sun, 17 Aug 2014 15:49:41 +0300

> The "rcu_dereference()" call is used directly in a condition.
> Since its return value is never dereferenced it is recommended to use
> "rcu_access_pointer()" instead of "rcu_dereference()".
> Therefore, this patch makes the replacement.
 ...
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>

Applied.
