Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177Ab3EBSVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:21:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59124 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760464Ab3EBSVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:21:52 -0400
Date: Thu, 02 May 2013 14:21:49 -0400 (EDT)
Message-Id: <20130502.142149.112188322974018320.davem@davemloft.net>
To: dcbw@redhat.com
Cc: mirqus@gmail.com, torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367518532.7757.14.camel@dcbw.foobar.com>
References: <20130502.135542.1332946768988319212.davem@davemloft.net>
	<20130502.140648.1138582574178897490.davem@davemloft.net>
	<1367518532.7757.14.camel@dcbw.foobar.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 11:21:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dcbw@redhat.com>
Date: Thu, 02 May 2013 13:15:32 -0500

> So it's got to be something else other than the netdev features ordering
> that's screwing up for Linus.  I'm sure we'd have heard about it a long,
> long time ago if something had messed up dev->flags bits...

We know for a fact that reordering the feature bits makes the link not
show as up in NM.

And we know that, when this happens, the driver and the kernel
internally both know that the link is up.

But how this ties into NM being confused about the link state is what
we're trying to find out.  It's still a mystery to me too.

