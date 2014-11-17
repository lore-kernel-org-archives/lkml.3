Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaKQCI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 21:08:26 -0500
Received: from mail.passe0815.de ([188.40.49.9]:56596 "EHLO mail.passe0815.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbaKQCIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 21:08:23 -0500
Date: Mon, 17 Nov 2014 03:08:16 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: "David S. Miller" <davem@davemloft.net>
Cc: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: fix netfilter/NF_BR_LOCAL_OUT for own, locally
 generated queries
Message-ID: <20141117020816.GD2469@odroid>
References: <1411342364-4791-1-git-send-email-linus.luessing@web.de>
 <20141102220145.GA25604@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141102220145.GA25604@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-GPG-Mailgate: Not encrypted, public key not found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 06:01:46AM +0800, Herbert Xu wrote:
> On Mon, Sep 22, 2014 at 01:32:44AM +0200, Linus Lüssing wrote:
> > Signed-off-by: Linus Lüssing <linus.luessing@web.de>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Hi David,

are there any unanswered questions left?

Cheers, Linus
