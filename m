Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3L3JFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 04:05:36 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:44337 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3L3JFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 04:05:33 -0500
Date: Mon, 30 Dec 2013 17:04:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>, Tim Chen <tim.c.chen@linux.intel.com>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-crypto@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: randconfig build error with next-20131223, in
 arch/x86/crypto/aesni-intel_avx.S
Message-ID: <20131230090450.GA8636@gondor.apana.org.au>
References: <CA+r1Zhh5As3QByXMvz0ha5Or2Xtxa3Y=QzuR75O7FwBKTk8XVA@mail.gmail.com>
 <20131223160238.GA15360@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131223160238.GA15360@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 05:02:38PM +0100, Borislav Petkov wrote:
> On Mon, Dec 23, 2013 at 08:09:18AM -0700, Jim Davis wrote:
> > Building with the attached random configuration file,
> > 
> > arch/x86/crypto/aesni-intel_avx.S: Assembler messages:
> > arch/x86/crypto/aesni-intel_avx.S:1449: Error: bad register name `%r12'
> > [...]
> > arch/x86/crypto/aesni-intel_avx.S:2807: Error: bad register name `%r12'
> > make[2]: *** [arch/x86/crypto/aesni-intel_avx.o] Error 1
> 
> > #
> > # Automatically generated file; DO NOT EDIT.
> > # Linux/x86 3.13.0-rc5 Kernel Configuration
> > #
> > # CONFIG_64BIT is not set
> > CONFIG_X86_32=y
> 
> Sounds like this aesni-intel_avx.S thing wasn't meant to be built for
> 32-bit.

Indeed.  Tim, can you provide me with a fix for this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
