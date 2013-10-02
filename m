Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3JBUBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:01:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48632 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3JBUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:01:22 -0400
Date: Wed, 02 Oct 2013 16:01:19 -0400 (EDT)
Message-Id: <20131002.160119.576160745622423553.davem@davemloft.net>
To: jj@chaosbits.net
Cc: mac@melware.de, isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: eicon: free pointer after using it in log msg in
 divas_um_idi_delete_entity()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1309302119550.4992@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1309302119550.4992@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 13:01:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Mon, 30 Sep 2013 21:25:27 +0200 (CEST)

> Not really a problem, but nice IMHO; the Coverity static analyzer
> complains that we use the pointer 'e' after it has been freed, so move
> the freeing below the final use, even if that use is just using the
> value of the pointer and not actually dereferencing it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied to net-next, thanks.
