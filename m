Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaKDDin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:38:43 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59680 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaKDDik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:38:40 -0500
Date: Tue, 4 Nov 2014 11:38:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [0/3] net: Kill skb_copy_datagram_const_iovec
Message-ID: <20141104033818.GA11149@gondor.apana.org.au>
References: <20141103002207.GA26588@gondor.apana.org.au>
 <20141103004503.GX7996@ZenIV.linux.org.uk>
 <20141103053751.GA27845@gondor.apana.org.au>
 <20141103.150553.633529234958324183.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103.150553.633529234958324183.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 03:05:53PM -0500, David Miller wrote:
>
> I'll see if I can make some progress converting the networking over
> to iov_iter.  It can't be that difficult... albeit perhaps a little
> time consuming.

OK great.  I'll try to convert tun/macvtap over to iov_iter.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
