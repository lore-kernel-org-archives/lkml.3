Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaLJCtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:49:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41353 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLJCtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:49:39 -0500
Date: Tue, 09 Dec 2014 21:49:37 -0500 (EST)
Message-Id: <20141209.214937.30977416178126165.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: edumazet@google.com, john.r.fastabend@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] fix suspicious rcu_dereference_check in
 net/sched/sch_fq_codel.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <58905.1418159750@turing-police.cc.vt.edu>
References: <58905.1418159750@turing-police.cc.vt.edu>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 18:49:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Date: Tue, 09 Dec 2014 16:15:50 -0500

> commit 46e5da40ae (net: qdisc: use rcu prefix and silence
>  sparse warnings) triggers a spurious warning:
> 
> net/sched/sch_fq_codel.c:97 suspicious rcu_dereference_check() usage!
> 
> The code should be using the _bh variant of rcu_dereference.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Applied and queued up for -stable, thanks.
