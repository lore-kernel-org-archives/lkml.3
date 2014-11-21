Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbaKUCmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:42:36 -0500
Received: from mail.eperm.de ([89.247.134.16]:54713 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049AbaKUCmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:42:35 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Fri, 21 Nov 2014 03:42:29 +0100
Message-ID: <2783267.MhpunSrNbJ@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141121023131.GA3873@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <6655976.jRkjMUZ19x@tachyon.chronox.de> <20141121023131.GA3873@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 21. November 2014, 10:31:31 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 20, 2014 at 05:08:42PM +0100, Stephan Mueller wrote:
> > Am Donnerstag, 20. November 2014, 21:40:29 schrieb Herbert Xu:
> > 
> > Hi Herbert,
> > 
> > > On Thu, Nov 20, 2014 at 02:10:00PM +0100, Stephan Mueller wrote:
> > > > What about the following
> > > > 
> > > > if (p->cru_driver_name[0]
> > 
> > If the driver name is not empty
> > 
> > > > 	alg = crypto_alg_match(p, 1);
> > 
> > Do an exact match using the driver name
> > 
> > > > else
> > > > 
> > > > 	alg = crypto_alg_match(p, 0);
> > 
> > Otherise use the generic name for a fuzzy match.
> > 
> > > If cru_driver_name is not empty then exact will never be used, no?
> > 
> > If the code suggestion does not follow my words outlined above, I want my
> > words to be considered ;-)
> > 
> > Yet, I am unsure where the code deviates from my words.
> 
> No I am asking how is this different from my patch?

Sorry, I withdraw my comment. Your patch is good as is after rechecking 
crypto_alg_match.

> 
> Cheers,


-- 
Ciao
Stephan
