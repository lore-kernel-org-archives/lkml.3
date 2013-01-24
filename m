Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3AXNAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:00:14 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:24699 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3AXNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:00:10 -0500
Date: Thu, 24 Jan 2013 08:00:08 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Message-ID: <148213573.113844.1359032408032.JavaMail.root@elliptictech.com>
In-Reply-To: <20130124125234.GL9147@secunet.com>
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent,
 and testmgr build issues
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steffen Klassert" <steffen.klassert@secunet.com>
> To: "Tom St Denis" <tstdenis@elliptictech.com>
> Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
> linux-crypto@vger.kernel.org, "David Miller" <davem@davemloft.net>, "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
> Sent: Thursday, 24 January, 2013 7:52:34 AM
> Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent, and testmgr build issues
> 
> On Thu, Jan 24, 2013 at 07:37:50AM -0500, Tom St Denis wrote:
> > 
> > Also a question for the netdev folk, in order to be timely would it
> > be acceptable to patch ah4 and then ah6 with the AEAD changes?  Or
> > would the team require both to be patched simultaneously?
> >  
> 
> We would need patches for both, but the changes to ah4/ah6 should
> e very similar.

I suspect, I just don't know how my time table will look like so I was trying to not block the submission of one by the other.  Fortunately, I don't need hardware to test these changes so I can probably skunkwork them from home.

Tom
