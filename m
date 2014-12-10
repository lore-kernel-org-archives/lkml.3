Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaLJTtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:49:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47155 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbaLJTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:45 -0500
Date: Wed, 10 Dec 2014 14:49:43 -0500 (EST)
Message-Id: <20141210.144943.1497210993149601967.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, Thomas.Lendacky@amd.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141210122036.133457c9@canb.auug.org.au>
References: <20141210122036.133457c9@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 11:49:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 10 Dec 2014 12:20:36 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/amd/xgbe/xgbe-desc.c between commit 03ccc4c0a9da
> ("amd-xgbe: Do not clear interrupt indicator") from the net tree and
> commit c9f140ebb008 ("amd-xgbe: Separate Tx/Rx ring data fields into
> new structs") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

As you have seen there are a lot of merge hassles to sort out between
the 'net' and 'net-next' tree right now, probably I just added a few
more :-)

I'll try to do the merge by the end of today so that these headaches
go away for you.

Thanks.
