Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3DWAmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 20:42:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40695 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3DWAmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 20:42:04 -0400
Date: Mon, 22 Apr 2013 20:42:02 -0400 (EDT)
Message-Id: <20130422.204202.847934226356654222.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130422130939.9162d4f519402dcfc4cdbe0c@canb.auug.org.au>
References: <20130422130939.9162d4f519402dcfc4cdbe0c@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 22 Apr 2013 17:42:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 22 Apr 2013 13:09:39 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> include/net/scm.h between commit 83f1b4ba917d ("net: fix incorrect
> credentials passing") from Linus' tree and commit 6b0ee8c036ec ("scm:
> Stop passing struct cred") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).  I also applied the following merge fix patch (I am not
> sure if this is correct, but it seems to be consistent):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 22 Apr 2013 13:06:10 +1000
> Subject: [PATCH] net: af_unix fix for incorrect credentials passing
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I took care of this during the net --> net-next merge, thanks!
