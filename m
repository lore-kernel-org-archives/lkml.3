Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaHAOkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:40:51 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36068 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaHAOku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:40:50 -0400
Date: Fri, 1 Aug 2014 22:40:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto/testmgr: add missing spaces to drbg error strings
Message-ID: <20140801144041.GE15005@gondor.apana.org.au>
References: <1406663276-25549-1-git-send-email-jarod@redhat.com>
 <4722634.TRQ80mFtKb@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4722634.TRQ80mFtKb@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 08:24:11PM +0200, Stephan Mueller wrote:
> Am Dienstag, 29. Juli 2014, 15:47:56 schrieb Jarod Wilson:
> 
> Hi Jarod,
> 
> >There are a few missing spaces in the error text strings for
> >drbg_cavs_test, trivial fix.
> 
> Thanks a lot.
> >
> >CC: Stephan Mueller <smueller@chronox.de>
> >CC: Herbert Xu <herbert@gondor.apana.org.au>
> >CC: "David S. Miller" <davem@davemloft.net>
> >CC: linux-crypto@vger.kernel.org
> >Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> Acked-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
