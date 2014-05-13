Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbaEMEH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 00:07:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34690 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaEMEHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 00:07:55 -0400
Date: Tue, 13 May 2014 00:07:53 -0400 (EDT)
Message-Id: <20140513.000753.538591395030698596.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com
Subject: Re: linux-next: manual merge of the net-next tree with the ipsec
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140513135322.3dfadb7c@canb.auug.org.au>
References: <20140513135322.3dfadb7c@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 May 2014 21:07:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 13 May 2014 13:53:22 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> net/ipv6/xfrm6_output.c between commit 5596732fa8c1 ("xfrm: Fix crash
> with ipv6 IPsec tunnel and NAT") from the ipsec tree and commit
> 60ff746739bf ("net: rename local_df to ignore_df") from the net-next
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks Stephen.
