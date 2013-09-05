Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3IEQgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:36:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33551 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3IEQgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:36:31 -0400
Date: Thu, 05 Sep 2013 12:36:26 -0400 (EDT)
Message-Id: <20130905.123626.1950323953517801491.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, amwang@redhat.com,
        linux@baker-net.org.uk
Subject: Re: bride: IPv6 multicast snooping enhancements
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378253619-23918-1-git-send-email-linus.luessing@web.de>
References: <1378253619-23918-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 09:36:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Wed,  4 Sep 2013 02:13:37 +0200

> Here are two, small feature changes I would like to submit to increase
> the usefulness of the multicast snooping of the bridge code.
> 
> The first patch is an unaltered one I had submitted before, but since it
> got no feedback I'm resubmitting it here for net-next. With the recently
> added patch to disable snooping if there is no querier (b00589af + 248ba8ec05
> + 8d50af4fb), it should be a safe choice now (without these, patch 1/2 would
> have introduced another potential for lost IPv6 multicast packets).
> 
> Both conceptually and also with some testing and fuzzing, I couldn't spot
> any more causes for potential packet loss. And since the multicast snooping
> code has now been tried by various people, I think it should be a safe
> choice to apply the multicast snooping not only for IPv6 multicast packets
> with a scope greater than link-local, but also for packets of exactly this
> scope. The IPv6 standard mandates MLD reports for link-local multicast, too,
> so we can safely snoop them as well (in contrast to IPv4 link-local).

Both patches applied, thanks!
