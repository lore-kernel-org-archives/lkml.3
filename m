Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab3IFC6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 22:58:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55212 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3IFC6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 22:58:19 -0400
Date: Thu, 05 Sep 2013 22:58:17 -0400 (EDT)
Message-Id: <20130905.225817.700066425182547791.davem@davemloft.net>
To: olof@lixom.net
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] net: stmmac: fix bad merge conflict resolution
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378429301-19964-1-git-send-email-olof@lixom.net>
References: <20130905.163725.106795517693348522.davem@davemloft.net>
	<1378429301-19964-1-git-send-email-olof@lixom.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 19:58:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Thu,  5 Sep 2013 18:01:41 -0700

> Merge commit 06c54055bebf919249aa1eb68312887c3cfe77b4 did a bad conflict
> resolution accidentally leaving out a closing brace. Add it back.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
> 
> This breaks a handful of defconfigs on ARM, so it'd be good to see it
> applied pretty quickly. Thanks!

Looks like Linus applied this, thanks Olof.
