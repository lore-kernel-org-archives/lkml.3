Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab3EXJ5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:57:21 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:55277 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752248Ab3EXJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:57:19 -0400
Date: Fri, 24 May 2013 17:57:15 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the crypto tree
Message-ID: <20130524095715.GA1410@gondor.apana.org.au>
References: <20130521114548.a7bc47b2247f39ec40c44e33@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521114548.a7bc47b2247f39ec40c44e33@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 11:45:48AM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> After merging the crypto tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> arch/x86/crypto/crct10dif-pclmul_glue.c: In function 'crct10dif_intel_mod_init':
> arch/x86/crypto/crct10dif-pclmul_glue.c:140:3: error: implicit declaration of function 'crc_t10dif_update_lib' [-Werror=implicit-function-declaration]
>    crc_t10dif_update_lib();
>    ^
> cc1: some warnings being treated as errors
> 
> Caused by commit b85ed9f056ee ("crypto: crct10dif - Glue code to cast
> accelerated CRCT10DIF assembly as a crypto transform").
> 
> I have used the version of the crypto tree from next-20130520 for today.

Sorry for the late response, it should be fixed now.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
