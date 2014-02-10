Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaBJDO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:14:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49363 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaBJDOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:14:54 -0500
Date: Sun, 09 Feb 2014 19:14:53 -0800 (PST)
Message-Id: <20140209.191453.505244720024526564.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH][Trivial] tcp: correct code comment stating 3 min
 timeout for FIN_WAIT2, we only do 1 min
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1402092328270.8418@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1402092328270.8418@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 9 Feb 2014 23:30:32 +0100 (CET)

> As far as I can tell we have used a default of 60 seconds for
> FIN_WAIT2 timeout for ages (since 2.x times??).
> 
> In any case, the timeout these days is 60 seconds, so the 3 min
> comment is wrong (and cost me a few minutes of my life when I was
> debugging a FIN_WAIT2 related problem in a userspace application and
> checked the kernel source for details).
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks.
