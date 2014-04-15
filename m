Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaDOGIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:08:48 -0400
Received: from mail.eperm.de ([89.247.134.16]:54253 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaDOGIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:08:47 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com
Subject: Re: [PATCH v5 1/6] SP800-90A Deterministic Random Bit Generator
Date: Tue, 15 Apr 2014 08:08:14 +0200
Message-ID: <1520003.UOH14fpcBO@myon.chronox.de>
User-Agent: KMail/4.12.3 (Linux/3.13.9-200.fc20.x86_64; KDE/4.12.3; x86_64; ; )
In-Reply-To: <1397541065.16090.11.camel@joe-AO722>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <1635225.UnHjb6h9ND@myon.chronox.de> <1397541065.16090.11.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. April 2014, 22:51:05 schrieb Joe Perches:

Hi Joe,

> On Tue, 2014-04-15 at 07:35 +0200, Stephan Mueller wrote:
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> 
> []
> 
> > @@ -0,0 +1,1997 @@
> 
> []
> 
> > +/***************************************************************
> > + * Backend cipher definitions available to DRBG
> > + ***************************************************************/
> > +
> > +const struct drbg_core cores[] = {
> 
> cores isn't a very good global name.
> I presume this should be static.

Agreed. static added and renamed to drbg_cores. I will wait a few days before 
releasing a new version. Maybe other comments show up.

Thanks for the review.

Ciao
Stephan
-- 
| Cui bono? |
