Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3GIXGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:06:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60730 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3GIXGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:06:14 -0400
Date: Tue, 09 Jul 2013 16:06:11 -0700 (PDT)
Message-Id: <20130709.160611.636749585237773459.davem@davemloft.net>
To: corbet@lwn.net
Cc: eliezer.tamir@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, dwmw2@infradead.org, eliezer@tamir.org.il
Subject: Re: [PATCH net-next] net: rename low latency sockets functions to
 busy poll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130709162514.062f1361@lwn.net>
References: <20130708132034.17639.4396.stgit@ladj378.jer.intel.com>
	<20130709162514.062f1361@lwn.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>
Date: Tue, 9 Jul 2013 16:25:14 -0600

> On Mon, 08 Jul 2013 16:20:34 +0300
> Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:
> 
>> Rename POLL_LL to POLL_BUSY_LOOP.
> 
> So pardon me if I speak out of turn, but it occurs to me to
> wonder...should the SO_LL socket option be renamed in a similar fashion
> before this interface escapes into the wild?

Sure and we can rename include/net/ll_poll.h to something more
fitting as well.

I'll make sure this happens before 3.11 gets even close to release.
