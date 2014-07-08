Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaGHXNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:13:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54981 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGHXNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:13:42 -0400
Date: Tue, 08 Jul 2014 16:13:41 -0700 (PDT)
Message-Id: <20140708.161341.103939871003850198.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH net-next 0/4] bridge: multicast snooping exports #2
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404704477-19448-1-git-send-email-linus.luessing@web.de>
References: <1404704477-19448-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 16:13:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Mon,  7 Jul 2014 05:41:15 +0200


"0/4"?  Surely you meant "0/2" :-)

> Some people pointed out to me that it might be helpful to add stubs for
> the newly added multicast exports. That way e.g. batman-adv should continue
> to be compile and useable without having to have a kernel compiled
> with bridge code in the future. This is what the first patch is supposed
> to do.
> 
> The second patch adds a third multicast export for the bridge which
> e.g. batman-adv is supposed to use, too, soon: Just like the bridge
> disables its multicast snooping activities if no querier is present,
> batman-adv needs to do the same if bridges are involved.
> 
> 
> These three exports should be the final ones needed to marry the bridge
> multicast snooping with the batman-adv multicast optimizations recently
> added for the 3.15 kernel, allowing to use these optimzations in common
> setups having a bridge on top of e.g. bat0, too. So far these bridged
> setups would fall back to simple flooding through the batman-adv mesh
> network for any multicast packet entering bat0.
> 
> More information about the batman-adv multicast optimizations currently
> implemented can be found here:
> 
> http://www.open-mesh.org/projects/batman-adv/wiki/Basic-multicast-optimizations
> 
> The integration on the batman-adv side could afterwards look like this,
> for instance (now including the third export):
> 
> http://git.open-mesh.org/batman-adv.git/commitdiff/61e4f6af4b7a21ed4040f2e711d50c778e5b6d93?hp=6ae4281474675fbca5bedcf768972a32db586eb6

Series applied, thanks.
