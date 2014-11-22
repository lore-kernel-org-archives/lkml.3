Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaKVDa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 22:30:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaKVDa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 22:30:27 -0500
Date: Fri, 21 Nov 2014 22:30:22 -0500 (EST)
Message-Id: <20141121.223022.399609321644415888.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jrajahalme@nicira.com,
        pshelar@nicira.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141117133404.525229b4@canb.auug.org.au>
References: <20141117133404.525229b4@canb.auug.org.au>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 19:30:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 17 Nov 2014 13:34:04 +1100

> I applied the following merge fix patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 17 Nov 2014 13:31:33 +1100
> Subject: [PATCH] openvswitch: fix up for OVS_NLERR API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks Stephen, I integrated this into the merge commit when
I merge net into net-next just now.

Thanks again.
