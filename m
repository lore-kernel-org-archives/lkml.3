Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3J2Vn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:43:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49004 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3J2Vn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:43:26 -0400
Date: Tue, 29 Oct 2013 17:43:25 -0400 (EDT)
Message-Id: <20131029.174325.408252313215165.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netconsole: Convert to pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382990001.8718.4.camel@joe-AO722>
References: <1382990001.8718.4.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 29 Oct 2013 14:43:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 28 Oct 2013 12:53:21 -0700

> Use a more current logging style.
> 
> Convert printks to pr_<level>.
> 
> Consolidate multiple printks into a single printk to avoid
> any possible dmesg interleaving.  Add a default "event" msg
> in case the listed types are ever expanded.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
