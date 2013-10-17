Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637Ab3JQT52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:57:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46695 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762281Ab3JQT51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:57:27 -0400
Date: Thu, 17 Oct 2013 15:57:24 -0400 (EDT)
Message-Id: <20131017.155724.740238353182278175.davem@davemloft.net>
To: rdunlap@infradead.org
Cc: thierry.reding@gmail.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, broonie@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH -next] netdev: inet_timewait_sock.h missing semi-colon
 when KMEMCHECK is enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <525C47C0.2000907@infradead.org>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
	<525C47C0.2000907@infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 17 Oct 2013 12:57:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 14 Oct 2013 12:36:32 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix (a few hundred) build errors due to missing semi-colon when
> KMEMCHECK is enabled:
> 
>   include/net/inet_timewait_sock.h:139:2: error: expected ',', ';' or '}' before 'int'
>   include/net/inet_timewait_sock.h:148:28: error: 'const struct inet_timewait_sock' has no member named 'tw_death_node'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks Randy.
