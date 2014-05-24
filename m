Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaEXEuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 00:50:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58443 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaEXEuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 00:50:37 -0400
Date: Sat, 24 May 2014 00:50:33 -0400 (EDT)
Message-Id: <20140524.005033.220770104598902823.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, vyasevic@redhat.com, vfalico@gmail.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140523134602.4dac2f7c@canb.auug.org.au>
References: <20140523134602.4dac2f7c@canb.auug.org.au>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 May 2014 21:50:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 23 May 2014 13:46:02 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/bonding/bond_alb.c between commit d0c21d43a5a1 ("bonding:
> Send ALB learning packets using the right source") from the net tree
> and commit 8557cd74ca8a ("bonding: replace SLAVE_IS_OK() with
> bond_slave_can_tx()") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen, I just merged net into net-next and this conflict
should therefore be gone.
