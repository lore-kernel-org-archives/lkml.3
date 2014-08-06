Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaHFB6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:58:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33909 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaHFB6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:58:10 -0400
Date: Tue, 05 Aug 2014 18:58:09 -0700 (PDT)
Message-Id: <20140805.185809.743966176538113451.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpicco@meloft.net
Subject: Re: linux-next: manual merge of the sparc-next tree with the sparc
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140806095845.25491f00@canb.auug.org.au>
References: <20140806095845.25491f00@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 18:58:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 6 Aug 2014 09:58:45 +1000

> Today's linux-next merge of the sparc-next tree got a conflict in
> arch/sparc/mm/init_64.c between commit 4ca9a23765da ("sparc64: Guard
> against flushing openfirmware mappings") from the sparc tree and commit
> f6d4fb5cc047 ("sparc64 - add mem to iomem resource") from the
> sparc-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen, simple non-overlapping additions and I'm about to push
that resolution to my tree.

Thanks again!
