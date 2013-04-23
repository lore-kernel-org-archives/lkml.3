Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3DWAix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 20:38:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40633 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3DWAiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 20:38:51 -0400
Date: Mon, 22 Apr 2013 20:38:46 -0400 (EDT)
Message-Id: <20130422.203846.798313857495836249.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ordex@autistici.org,
        lindner_marek@yahoo.de, martin@hundeboll.net
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130419125304.9980f9b037abf00bef7b6f8c@canb.auug.org.au>
References: <20130419125304.9980f9b037abf00bef7b6f8c@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 22 Apr 2013 17:38:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 Apr 2013 12:53:04 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> net/batman-adv/routing.c between commit fe8a93b95145 ("batman-adv: make
> is_my_mac() check for the current mesh only") from the net tree and
> commits f86ce0ad107b ("batman-adv: Return reason for failure in
> batadv_check_unicast_packet()") and 612d2b4fe0a1 ("batman-adv: network
> coding - save overheard and tx packets for decoding") from the net-next
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

I've merged net into net-next and added all the necessary fixups
in the merge commit.

Thanks!
