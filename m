Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3ARUxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:53:47 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:25801 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3ARUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:53:45 -0500
Date: Fri, 18 Jan 2013 15:53:44 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: David Miller <davem@davemloft.net>
Cc: steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <220318679.90938.1358542424387.JavaMail.root@elliptictech.com>
In-Reply-To: <20130118.145005.156366015893075594.davem@davemloft.net>
Subject: Re: IPsec AH use of ahash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "David Miller" <davem@davemloft.net>
> To: tstdenis@elliptictech.com
> Cc: "steffen klassert" <steffen.klassert@secunet.com>, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
> netdev@vger.kernel.org
> Sent: Friday, 18 January, 2013 2:50:05 PM
> Subject: Re: IPsec AH use of ahash
> 
> From: Tom St Denis <tstdenis@elliptictech.com>
> Date: Fri, 18 Jan 2013 14:35:33 -0500 (EST)
> 
> > Any "maintainers" going to reply to this at all?
> 
> What do you mean?  There was a reply, and the reply if someone
> so skilled finds this facility useful they can feel free to
> submit an implementation.
> 
> You can't force people to work on something they have no interest
> in, especially when it's effectively a new feature.
> 

Admittedly I'm new to the kernel scene but what exactly is a "maintainer" then?

Suppose I invest time to re-write the IPv4/v6 AH code to correctly use AEAD instead of ahash, to then perform the testing required, etc... do I get credit as a maintainer in the IPsec tree?

I'm also a little annoyed that my CMAC patch was rejected for among other reasons that it violated "coding standards."  Specially since it was almost entirely copied from crypto/xcbc.c which also violates the same rules.  As a newcomer to the tree I tried my best by emulating readily available code (which apparently was already accepted into the tree) to then just get shot down for attempting to contribute.  If my CMAC code is not good enough for the tree I humbly suggest you also remove the XCBC code too while we're at it.

What I would expect from the "maintainers" is that they actually take on a more than trivial involvement in the progress of the code.  If I have to create original content and massage it into whatever form pleases the owners of the tree am I not the maintainer of the code?  I was honestly expecting someone with more involvement in the tree to move the [in this case] CMAC patch forward.  

As for the AH side if it's the implied intent of the maintainers to not support all relevant [and ideally low hanging fruit] standards as possible this should be stated explicitly.

Tom
