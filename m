Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3BSBaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:30:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3BSBaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:30:24 -0500
Date: Mon, 18 Feb 2013 20:30:18 -0500 (EST)
Message-Id: <20130218.203018.1503258377581298518.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
        r.kuntz@ipflavors.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130219121722.c5470cdd2040712deb8e8043@canb.auug.org.au>
References: <20130219121722.c5470cdd2040712deb8e8043@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Feb 2013 17:30:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 19 Feb 2013 12:17:22 +1100

> I assume that the problem fixed by the net tree commit is fixed some
> other way in the net-next tree, so I reverted the net tree commit.

The net tree commit should be simply reverted, yes.
