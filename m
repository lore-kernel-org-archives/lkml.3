Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3C0Eyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:54:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51218 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab3C0Eyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:54:54 -0400
Date: Wed, 27 Mar 2013 00:54:52 -0400 (EDT)
Message-Id: <20130327.005452.686619573507820021.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, pshelar@nicira.com
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130327115743.7d6c10f1e1c67f02e9c96ff8@canb.auug.org.au>
References: <20130327115743.7d6c10f1e1c67f02e9c96ff8@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 26 Mar 2013 21:54:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 27 Mar 2013 11:57:43 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> include/net/ipip.h between commit 330305cc4a6b ("pv4: Fix ip-header
> identification for gso packets") from Linus' tree and commit c54419321455
> ("GRE: Refactor GRE tunneling code") from the net-next tree.
> 
> I just dropped the file (as the latter change did) and can carry the fix
> as necessary (no action is required).

Thanks, I'll take care of this when I next merge.

