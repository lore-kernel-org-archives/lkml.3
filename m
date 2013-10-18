Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3JRRym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:54:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57073 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3JRRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:54:41 -0400
Date: Fri, 18 Oct 2013 13:54:27 -0400 (EDT)
Message-Id: <20131018.135427.1167985246850003150.davem@davemloft.net>
To: baker.kernel@gmail.com
Cc: eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] fib_trie: remove duplicated rcu lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381665009-4436-1-git-send-email-baker.kernel@gmail.com>
References: <1381636737.3392.29.camel@edumazet-glaptop.roam.corp.google.com>
	<1381665009-4436-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 18 Oct 2013 10:54:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: baker.kernel@gmail.com
Date: Sun, 13 Oct 2013 19:50:09 +0800

> From: "baker.zhang" <baker.kernel@gmail.com>
> 
> fib_table_lookup has included the rcu lock protection.
> 
> Signed-off-by: baker.zhang <baker.kernel@gmail.com>

Applied, thanks.
