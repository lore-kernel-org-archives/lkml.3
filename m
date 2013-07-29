Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3G2Hrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:47:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41639 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3G2Hrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:47:47 -0400
Date: Mon, 29 Jul 2013 00:47:46 -0700 (PDT)
Message-Id: <20130729.004746.91827990830866654.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, tgraf@suug.ch
Subject: Re: linux-next: build failure after merge of the final tree
 (netnext-tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130729162544.574e4d7ffccf0f6bff5ba4c4@canb.auug.org.au>
References: <20130729162544.574e4d7ffccf0f6bff5ba4c4@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 29 Jul 2013 00:47:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Jul 2013 16:25:44 +1000

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:

Sorry about that.

> I added this commit:

Applied, thanks Stephen.
