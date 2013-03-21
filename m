Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3CUUV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:21:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46678 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3CUUVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:21:54 -0400
Date: Thu, 21 Mar 2013 16:21:53 -0400 (EDT)
Message-Id: <20130321.162153.1171536447340639084.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuj97@gmail.com, tkhai@yandex.ru
Subject: Re: linux-next: manual merge of the akpm tree with the sparc-next
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130321163328.2c6dccabad6a8dc8fe4b0e24@canb.auug.org.au>
References: <20130321163328.2c6dccabad6a8dc8fe4b0e24@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 21 Mar 2013 13:21:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 21 Mar 2013 16:33:28 +1100

> Today's linux-next merge of the akpm tree got a conflict in
> arch/sparc/mm/init_64.c between commit ce835e513a93 ("sparc64: Do not
> change num_physpages during initmem freeing") from the sparc-next tree
> and commit "mm/SPARC: use common help functions to free reserved pages"
> from the akpm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This was expected, and the merge resolution looks fine to me,
thanks Stephen!
