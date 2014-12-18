Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaLREhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 23:37:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41848 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaLREhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 23:37:32 -0500
Date: Wed, 17 Dec 2014 23:37:29 -0500 (EST)
Message-Id: <20141217.233729.323289791259636663.davem@davemloft.net>
To: dan@dcollins.co.nz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed TPACKET V3 to signal poll when block is closed
 rather than for every packet
From: David Miller <davem@davemloft.net>
In-Reply-To: <14a5a65c372.fa01df65100787.352762707968323665@dcollins.co.nz>
References: <14a5a65c372.fa01df65100787.352762707968323665@dcollins.co.nz>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Dec 2014 20:37:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Collins <dan@dcollins.co.nz>
Date: Thu, 18 Dec 2014 12:36:56 +1300


> Make TPACKET_V3 signal poll when block is closed rather than for every packet. Side effect is that poll will be signaled when block retire timer expires which didn't previously happen. Issue was visible when sending packets at a very low frequency such that all blocks are retired before packets are received by TPACKET_V3. This caused avoidable packet loss. The fix ensures that the signal is sent when blocks are closed which covers the normal path where the block is filled as well as the path where the timer expires. The case where a block is filled without moving to the next block (ie. all blocks are full) will still cause poll to be signaled.

Please format your commit messages to 80 column ascii formatted text.

> Signed-off-by: Dan Collins &lt;dan@dcollins.co.nz&gt;

You need real "<" and ">" characters here.
