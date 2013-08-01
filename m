Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3HABr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:47:29 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:58078 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752631Ab3HABr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:47:28 -0400
Date: Thu, 1 Aug 2013 11:47:19 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Joe Perches <joe@perches.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Andreas Westin <andreas.westin@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: crypto: ux500: Fix logging, make arrays const, neatening
Message-ID: <20130801014719.GC24286@gondor.apana.org.au>
References: <1373896210-21316-1-git-send-email-standby24x7@gmail.com>
 <1374003464-32302-1-git-send-email-standby24x7@gmail.com>
 <1374008808.1949.37.camel@joe-AO722>
 <CACRpkdaUQaDbtr5rOyob_G5ggSZLUVOWU+TmhL51Jw_c0S+T0A@mail.gmail.com>
 <1374535175.2061.84.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374535175.2061.84.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 04:19:35PM -0700, Joe Perches wrote:
> On Tue, 2013-07-23 at 00:35 +0200, Linus Walleij wrote:
> > Have you tested this on hardware or is it compile-tested only?
> 
> Hi Linus.
> 
> Compile tested only.  Not tested on real devices.  -ENOHARDWARE.

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
