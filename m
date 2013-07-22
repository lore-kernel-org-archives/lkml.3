Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab3GVUEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:04:37 -0400
Received: from mout.web.de ([212.227.15.14]:51362 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933259Ab3GVUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:04:35 -0400
Date: Mon, 22 Jul 2013 22:05:11 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
Subject: Re: [PATCH] bridge: prevent flooding IPv6 packets that do not have a
 listener
Message-ID: <20130722200511.GA5852@Linus-Debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1371815638-5618-1-git-send-email-linus.luessing@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:XQnIOXqFKF2h8bzfveAaspno64V5dPjrtFP4R1/iDylEvqiaZFl
 mE/BU1V0q68zTSC9G76+fg4OAvFYpIA5l0aaemZJZ3qSDLm48AA4fXf24J0H4/WSlbVb/GD
 xoDIZjiqwAixmrBx6TetBhsaGEsmOzqx9rkwEVSua2kurmcyvzkFDq2aecXuawzlRl1GfxN
 n9AFM6yiska8h30BgPgKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

Were there any reasons I might not be aware of which prevented you
from adding the same change you introduced in
"bridge: Only flood unregistered groups to routers" for IPv6, too?

If not and if no one else comes up with any objection, then I'd
still be happy if this patch could find its way upstream :).

Cheers, Linus
