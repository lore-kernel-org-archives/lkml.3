Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3AXMh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:37:58 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:5184 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3AXMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:37:52 -0500
Date: Thu, 24 Jan 2013 07:37:50 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Message-ID: <909599053.113808.1359031070783.JavaMail.root@elliptictech.com>
In-Reply-To: <20130124123210.GK9147@secunet.com>
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent,
 and testmgr build issues
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.112]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Steffen Klassert" <steffen.klassert@secunet.com>
> To: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
> Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-crypto@vger.kernel.org, "Tom St Denis" <tstdenis@elliptictech.com>, "David Miller" <davem@davemloft.net>
> Sent: Thursday, 24 January, 2013 7:32:10 AM
> Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent, and testmgr build issues
> 
> On Thu, Jan 24, 2013 at 01:25:46PM +0200, Jussi Kivilinna wrote:
> > 
> > Maybe it would be cleaner to not mess with pfkeyv2.h at all, but
> > instead mark algorithms that do not support pfkey with flag. See
> > patch below.
> > 
> 
> Yes, would be an option too. I would be fine with that,
> but let's here if someone else has an opinion on this.
> Anyway, we need a solution to integrate Tom's patch soon.

Has anyone addressed the testmgr issues too?  I wasn't able to run the self-tests so I don't even know if the vectors were copied correctly.

Also a question for the netdev folk, in order to be timely would it be acceptable to patch ah4 and then ah6 with the AEAD changes?  Or would the team require both to be patched simultaneously?
 
Tom
