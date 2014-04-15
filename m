Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaDOJGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:06:39 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:51091 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbaDOJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:06:36 -0400
Message-ID: <1397552794.1985.19.camel@x220>
Subject: Re: [PATCH 05/28] Remove MPILIB_EXTRA
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 11:06:34 +0200
In-Reply-To: <1391977123.25855.24.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-6-git-send-email-richard@nod.at>
	 <1391977123.25855.24.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 09:06:34.0518 (UTC) FILETIME=[FFF71360:01CF5889]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 21:18 +0100, Paul Bolle wrote:
> On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> > The symbol is an orphan, get rid of it.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Acked-by: Paul Bolle <pebolle@tiscali.nl>
> 
> > ---
> >  crypto/asymmetric_keys/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> > index 03a6eb9..0320c7d 100644
> > --- a/crypto/asymmetric_keys/Kconfig
> > +++ b/crypto/asymmetric_keys/Kconfig
> > @@ -22,7 +22,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> >  
> >  config PUBLIC_KEY_ALGO_RSA
> >  	tristate "RSA public-key algorithm"
> > -	select MPILIB_EXTRA
> >  	select MPILIB
> >  	help
> >  	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
> 
> I tried this a year ago (see https://lkml.org/lkml/2013/3/8/142 ).

Did anyone else ever find some time to look at this oneliner?


Paul Bolle

