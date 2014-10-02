Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaJBSZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:25:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46254 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaJBSZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:25:07 -0400
Date: Thu, 02 Oct 2014 11:27:08 -0700 (PDT)
Message-Id: <20141002.112708.1359594783225203915.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hayeswang@realtek.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141002141641.0e43a18e@canb.auug.org.au>
References: <20141002141641.0e43a18e@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Oct 2014 11:25:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 2 Oct 2014 14:16:41 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/usb/r8152.c between commit 204c87041289 ("r8152: remove
> clearing bp") from the net tree and commit 8ddfa07778af ("r8152: use
> usleep_range") from the net-next tree.
> 
> I fixed it up (the former removed some of the code updated by the
> latter) and can carry the fix as necessary (no action is required).

I'm merging net into net-next today and thus resolving this.

Thanks Stephen!
