Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3G3Hvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:51:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58586 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3G3HtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:49:24 -0400
Date: Tue, 30 Jul 2013 00:49:23 -0700 (PDT)
Message-Id: <20130730.004923.1092822113714066844.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH - diffstat only] include/net: Remove extern from
 function prototypes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130730173800.1825a1452694f40370699413@canb.auug.org.au>
References: <1374602291.3387.17.camel@joe-AO722>
	<20130730.001001.618776305200728182.davem@davemloft.net>
	<20130730173800.1825a1452694f40370699413@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 00:49:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 30 Jul 2013 17:38:00 +1000

> I must admit I prefer the other way (i.e. with the explicit extern).  If
> nothing else it makes it consistent with variable declarations in header
> files (which need the extern) and "static inlines" ...
> 
> Making these churn changes also will almost certainly cause unnecessary
> conflicts :-(

Regardless of preferences, the whole tree is a mix, and we should choose
one way or the other consistently.

It seems like new code in other major subsystems are using the
no-extern scheme, and I'm more than happy to follow suit.
