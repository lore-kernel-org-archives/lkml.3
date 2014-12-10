Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbaLJUw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:52:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47763 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbaLJUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:52:57 -0500
Date: Wed, 10 Dec 2014 15:52:55 -0500 (EST)
Message-Id: <20141210.155255.780108895512174661.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hariprasad@chelsio.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141210195405.5af40846@canb.auug.org.au>
References: <20141210195405.5af40846@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 12:52:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 10 Dec 2014 19:54:05 +1100

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 10 Dec 2014 19:48:02 +1100
> Subject: [PATCH] cxgb4/cxgb4vf: global named must be unique
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks.
