Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282AbaKMVON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:14:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59806 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934024AbaKMVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:14:11 -0500
Date: Thu, 13 Nov 2014 16:14:05 -0500 (EST)
Message-Id: <20141113.161405.1383394554354192003.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hariprasad@chelsio.com,
        alexander.h.duyck@redhat.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141113113555.15117365@canb.auug.org.au>
References: <20141113113555.15117365@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Nov 2014 13:14:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 13 Nov 2014 11:35:55 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/chelsio/cxgb4vf/sge.c between commit 65f6ecc93e7c
> ("cxgb4vf: Move fl_starv_thres into adapter->sge data structure") from
> the net tree and commit aa9cd31c3f3e ("cxgb4/cxgb4vf: Replace
> __skb_alloc_page with __dev_alloc_page") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This merge resolution looks perfect.
