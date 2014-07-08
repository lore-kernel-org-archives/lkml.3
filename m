Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaGHCxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:53:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48423 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaGHCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:53:31 -0400
Date: Mon, 07 Jul 2014 19:53:30 -0700 (PDT)
Message-Id: <20140707.195330.1593299312055099195.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, vbridgers2013@gmail.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140704113907.468a366a@canb.auug.org.au>
References: <20140704113907.468a366a@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Jul 2014 19:53:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 4 Jul 2014 11:39:07 +1000

> After merging the net tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "phy_resume" [drivers/net/ethernet/stmicro/stmmac/stmmac.ko] undefined!
> 
> Caused by commit 0acf16768740 ("net: stmmac: add platform init/exit for
> Altera's ARM socfpga").
> 
> I reverted that commit for today.

Vince you haven't made any effort to fix this build failure, so I am reverting
your changes.
