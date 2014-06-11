Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaFKGv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 02:51:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42834 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaFKGvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 02:51:24 -0400
Date: Tue, 10 Jun 2014 23:51:23 -0700 (PDT)
Message-Id: <20140610.235123.310487202447168937.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCHv4 net-next 0/4] bridge: multicast snooping patches /
 exports
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402158389-13239-1-git-send-email-linus.luessing@web.de>
References: <1402158389-13239-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Jun 2014 23:51:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Sat,  7 Jun 2014 18:26:25 +0200

> The first patch is simply a cosmetic patch. So far I (and maybe others
> too?) have been regularly confusing these two structs, therefore I'd
> suggest renaming them and therefore making the follow-up patches easier
> to understand and nicer to fit in.
> 
> The second patch fixes a minor issue, but probably not worth for stable.
> 
> On the other hand the first two patches are also preparations for the
> third and fourth patch:
> 
> These two patches are exporting functionality needed to marry the bridge
> multicast snooping with the batman-adv multicast optimizations recently
> added for the 3.15 kernel, allowing to use these optimzations in common
> setups having a bridge on top of e.g. bat0, too. So far these bridged
> setups would fall back to simple flooding through the batman-adv mesh
> network for any multicast packet entering bat0.

Series applied, thank you.
