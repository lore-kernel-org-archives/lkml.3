Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaANFTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:19:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaANFTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:19:48 -0500
Date: Mon, 13 Jan 2014 21:19:46 -0800 (PST)
Message-Id: <20140113.211946.205101073261467184.davem@davemloft.net>
To: hpa@zytor.com
Cc: sfr@canb.auug.org.au, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree with the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <52D4C25F.8060804@zytor.com>
References: <20140113142059.f9f1c58c391b2c8bbd05699f@canb.auug.org.au>
	<20140114140214.7279bcaf88d7a4514d889186@canb.auug.org.au>
	<52D4C25F.8060804@zytor.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 13 Jan 2014 20:51:43 -0800

> Is there a sensible way we can fix this in either net-next or tip?

I think if I sort the files in net-next the problem will go away,
if someone can confirm this I'll do it.
