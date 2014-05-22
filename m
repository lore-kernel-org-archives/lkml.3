Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaEVThq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:37:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41889 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEVTho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:37:44 -0400
Date: Thu, 22 May 2014 15:37:42 -0400 (EDT)
Message-Id: <20140522.153742.1822151259317153775.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: bridge: multicast snooping patches / exports
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400662742-31999-1-git-send-email-linus.luessing@web.de>
References: <1400662742-31999-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 12:37:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Wed, 21 May 2014 10:58:58 +0200

> These two patches are exporting functionality needed to marry the bridge
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
> for instance:
> 
> http://git.open-mesh.org/batman-adv.git/commitdiff/576b59dd3e34737c702e548b21fa72059262f796?hp=f95ce7131746c65fbcdffcf2089cab59e2c2f7ac

I'd really like to see some feedback from bridge folks before applying
this, thanks.
