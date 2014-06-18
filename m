Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbaFRIKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:10:02 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54301 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933617AbaFRIJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:09:57 -0400
Message-ID: <1403078994.1984.47.camel@x220>
Subject: Re: [PATCH 05/28] Remove MPILIB_EXTRA
From: Paul Bolle <pebolle@tiscali.nl>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <trivial@kernel.org>, Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 18 Jun 2014 10:09:54 +0200
In-Reply-To: <20140415092147.GA4302@pd.tnic>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-6-git-send-email-richard@nod.at>
	 <1391977123.25855.24.camel@x220> <1397552794.1985.19.camel@x220>
	 <20140415092147.GA4302@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2014 08:09:54.0779 (UTC) FILETIME=[B00012B0:01CF8ACC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 11:21 +0200, Borislav Petkov wrote:
> On Tue, Apr 15, 2014 at 11:06:34AM +0200, Paul Bolle wrote:
> > On Sun, 2014-02-09 at 21:18 +0100, Paul Bolle wrote:
> > > On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> > > > The symbol is an orphan, get rid of it.
> > > > 
> > > > Signed-off-by: Richard Weinberger <richard@nod.at>
> > > 
> > > Acked-by: Paul Bolle <pebolle@tiscali.nl>
> > > 
> > > > ---
> > > >  crypto/asymmetric_keys/Kconfig | 1 -
> > > >  1 file changed, 1 deletion(-)
> > > > 
> > > > diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> > > > index 03a6eb9..0320c7d 100644
> > > > --- a/crypto/asymmetric_keys/Kconfig
> > > > +++ b/crypto/asymmetric_keys/Kconfig
> > > > @@ -22,7 +22,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> > > >  
> > > >  config PUBLIC_KEY_ALGO_RSA
> > > >  	tristate "RSA public-key algorithm"
> > > > -	select MPILIB_EXTRA
> > > >  	select MPILIB
> > > >  	help
> > > >  	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
> > > 
> > > I tried this a year ago (see https://lkml.org/lkml/2013/3/8/142 ).
> > 
> > Did anyone else ever find some time to look at this oneliner?
> 
> Last time I asked about that part of the tree, Herbert said it should go
> through James Morris' tree. CCed.
> 
> http://lkml.kernel.org/r/20131112182746.GA22711@gondor.apana.org.au
> 
> Unless akpm picks it up first. Also CCed.

This oneliner is neither part of v3.16-rc1 nor part of linux-next. It
applies cleanly to next-20140618. Should I hope that Jiri Kosina wants
to take it for trivial (CC-ed)?


Paul Bolle

