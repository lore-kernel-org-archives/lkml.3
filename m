Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956AbaKVHYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 02:24:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44091 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaKVHYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 02:24:50 -0500
Date: Sat, 22 Nov 2014 02:24:44 -0500 (EST)
Message-Id: <20141122.022444.425003630662787798.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        nab@linux-iscsi.org, hch@infradead.org
Subject: Re: [RFC] situation with csum_and_copy_... API
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141122042856.GZ7996@ZenIV.linux.org.uk>
References: <20141120.182339.972861702759954603.davem@davemloft.net>
	<20141121.122615.1091044030302005883.davem@davemloft.net>
	<20141122042856.GZ7996@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 23:24:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sat, 22 Nov 2014 04:28:57 +0000

> 	OK, here's the next bunch.  Sorry about the delay, iov_iter.c stuff
> took most of the day (and it's not included in this pile).  Please, review.

I read over this stuff twice and this series looks fine to me.

Since this is the weekend... maybe wait until Monday for other feedback
then give me a pull request?

Thanks Al.
