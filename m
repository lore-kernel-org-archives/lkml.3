Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3LQUFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:05:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48609 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3LQUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:04:58 -0500
Date: Tue, 17 Dec 2013 15:04:56 -0500 (EST)
Message-Id: <20131217.150456.1467555049218669410.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: edumazet@google.com, netdev@vger.kernel.org, xemul@parallels.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: unix: allow bind to fail on mutex lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386950062-19020-1-git-send-email-sasha.levin@oracle.com>
References: <1386950062-19020-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 17 Dec 2013 12:04:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Fri, 13 Dec 2013 10:54:22 -0500

> This is similar to the set_peek_off patch where calling bind while the
> socket is stuck in unix_dgram_recvmsg() will block and cause a hung task
> spew after a while.
> 
> This is also the last place that did a straightforward mutex_lock(), so
> there shouldn't be any more of these patches.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied, thanks.
