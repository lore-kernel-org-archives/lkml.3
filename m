Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaDOJVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:21:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51209 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaDOJVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:21:50 -0400
Date: Tue, 15 Apr 2014 11:21:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/28] Remove MPILIB_EXTRA
Message-ID: <20140415092147.GA4302@pd.tnic>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-6-git-send-email-richard@nod.at>
 <1391977123.25855.24.camel@x220>
 <1397552794.1985.19.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397552794.1985.19.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:06:34AM +0200, Paul Bolle wrote:
> On Sun, 2014-02-09 at 21:18 +0100, Paul Bolle wrote:
> > On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> > > The symbol is an orphan, get rid of it.
> > > 
> > > Signed-off-by: Richard Weinberger <richard@nod.at>
> > 
> > Acked-by: Paul Bolle <pebolle@tiscali.nl>
> > 
> > > ---
> > >  crypto/asymmetric_keys/Kconfig | 1 -
> > >  1 file changed, 1 deletion(-)
> > > 
> > > diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> > > index 03a6eb9..0320c7d 100644
> > > --- a/crypto/asymmetric_keys/Kconfig
> > > +++ b/crypto/asymmetric_keys/Kconfig
> > > @@ -22,7 +22,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> > >  
> > >  config PUBLIC_KEY_ALGO_RSA
> > >  	tristate "RSA public-key algorithm"
> > > -	select MPILIB_EXTRA
> > >  	select MPILIB
> > >  	help
> > >  	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
> > 
> > I tried this a year ago (see https://lkml.org/lkml/2013/3/8/142 ).
> 
> Did anyone else ever find some time to look at this oneliner?

Last time I asked about that part of the tree, Herbert said it should go
through James Morris' tree. CCed.

http://lkml.kernel.org/r/20131112182746.GA22711@gondor.apana.org.au

Unless akpm picks it up first. Also CCed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
