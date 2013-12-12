Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3LLAgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:36:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60702 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LLAgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:36:40 -0500
Date: Wed, 11 Dec 2013 19:36:39 -0500 (EST)
Message-Id: <20131211.193639.2058525533631918382.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jasowang@redhat.com,
        wuzhy@linux.vnet.ibm.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131212111539.cff1b2efe934c5cd7abbb822@canb.auug.org.au>
References: <20131212111539.cff1b2efe934c5cd7abbb822@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 16:36:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Dec 2013 11:15:39 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/macvtap.c between commit ce232ce01d61 ("macvtap: signal
> truncated packets") from the net tree and commit 55ec8e25cd97 ("macvtap:
> remove unused parameter in macvtap_do_read()") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The net-next commit in question was reverted last night.
