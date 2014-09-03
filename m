Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936356AbaICXuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:50:51 -0400
Received: from mail.eperm.de ([89.247.134.16]:47010 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286AbaICXul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:50:41 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DRBG: remove check for uninitialized DRBG handle
Date: Thu, 04 Sep 2014 01:50:32 +0200
Message-ID: <8246803.Qk7EMfoFYT@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-201.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140903232129.GA32264@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au> <3575659.BooajjTQie@myon.chronox.de> <20140903232129.GA32264@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. September 2014, 07:21:29 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Sep 03, 2014 at 03:33:16AM +0200, Stephan Mueller wrote:
> > Am Montag, 1. September 2014, 07:11:20 schrieb Stephan Mueller:
> > 
> > Hi Herbert,
> > 
> > may I ask for consideration of this patch as this covers an oops FIPS
> > mode?
> > 
> > In addition, may I ask for guidance on how to fix the 32 bit code path in
> > Linus' tree as asked on 28.8? To quote: "Thus, the fix in
> > b9347aff91ce4789619168539f08202d8d6a1177 works. However, this
> > patch is based on 05c81ccd9087d238c10b234eadb55632742e5518. So, if we want
> > to fix Linus' tree with minimal impact, either these two patches are
> > pushed to Linus or I have to port
> > b9347aff91ce4789619168539f08202d8d6a1177 to the current Linus tree."
> 
> I will take care of this.

Thank you.
> 
> Cheers,


-- 
Ciao
Stephan
