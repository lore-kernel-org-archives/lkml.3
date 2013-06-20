Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113Ab3FTDhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:37:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48189 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965091Ab3FTDhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:37:14 -0400
Date: Wed, 19 Jun 2013 20:37:12 -0700 (PDT)
Message-Id: <20130619.203712.1274791928658538966.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, johannes.berg@intel.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130620125823.da633b21e33688372729b9c0@canb.auug.org.au>
References: <20130620125823.da633b21e33688372729b9c0@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 20 Jun 2013 12:58:23 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> net/wireless/nl80211.c between commit 3a5a423bb958 ("nl80211: fix attrbuf
> access race by allocating a separate one") from the net tree and commit
> 5fe231e87372 ("cfg80211: vastly simplify locking") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

I did this merge a few hours ago and hit the same conflict.

Although I fixed the bug in that rtnl_unlock() is not performed in
all the return code paths.
