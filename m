Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3HAAYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:24:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36346 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3HAAYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:24:38 -0400
Date: Wed, 31 Jul 2013 17:24:37 -0700 (PDT)
Message-Id: <20130731.172437.198780183941616730.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Remove extern from include/net/ scheduling
 prototypes
From: David Miller <davem@davemloft.net>
In-Reply-To: <470a8782ea89cee979eca82c7847748129de6bd0.1375249605.git.joe@perches.com>
References: <470a8782ea89cee979eca82c7847748129de6bd0.1375249605.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 31 Jul 2013 17:24:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 30 Jul 2013 22:47:13 -0700

> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
> 
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.
> 
> Reflow modified prototypes to 80 columns.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
