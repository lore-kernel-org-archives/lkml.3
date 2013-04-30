Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab3D3IEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:04:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41427 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3D3IEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:04:30 -0400
Date: Tue, 30 Apr 2013 04:04:28 -0400 (EDT)
Message-Id: <20130430.040428.2200075465405704834.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, gang.chen@asianux.com, alan@signal11.us
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130430122423.ab57c82604f13f6773ef4aeb@canb.auug.org.au>
References: <20130430122423.ab57c82604f13f6773ef4aeb@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Apr 2013 01:04:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 30 Apr 2013 12:24:23 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> net/mac802154/mac802154.h between commit 2c1bbbffa0b6 ("net: mac802154:
> comparision issue of type cast, finding by EXTRA_CFLAGS=-W") from the net
> tree and commit 7dd43d356e73 ("mac802154: Do not try to resend failed
> packets") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This should be taken care of as well, thanks Stephen.
