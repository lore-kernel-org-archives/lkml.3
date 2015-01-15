Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbbAOGGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 01:06:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48245 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbAOGGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 01:06:40 -0500
Date: Thu, 15 Jan 2015 01:06:38 -0500 (EST)
Message-Id: <20150115.010638.1588013062855266803.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20150115134735.1e4612c6@canb.auug.org.au>
References: <20150115134735.1e4612c6@canb.auug.org.au>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Jan 2015 22:06:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 15 Jan 2015 13:47:35 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/xen-netfront.c between commit 900e183301b5 ("xen-netfront:
> use different locks for Rx and Tx stats") from the net tree and commit
> a55e8bb8fb89 ("xen-netfront: refactor making Tx requests") from the
> net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks a lot Stephen, I just resolved this.
