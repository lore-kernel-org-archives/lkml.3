Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3DWAlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 20:41:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40689 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3DWAln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 20:41:43 -0400
Date: Mon, 22 Apr 2013 20:41:42 -0400 (EDT)
Message-Id: <20130422.204142.498231678158708544.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com, nanditad@google.com
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130422130324.43b4521c6b4719ed7a96ef00@canb.auug.org.au>
References: <20130422130324.43b4521c6b4719ed7a96ef00@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 22 Apr 2013 17:41:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 22 Apr 2013 13:03:24 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> net/ipv4/tcp_input.c between commit 12fb3dd9dc3c ("tcp: call
> tcp_replace_ts_recent() from tcp_ack()") from Linus' tree and commit
> 9b717a8d2450 ("tcp: TLP loss detection") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

I took care of this during the net --> net-next merge, thanks!
