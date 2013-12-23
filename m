Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab3LWQCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:02:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39802 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab3LWQCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:02:42 -0500
Date: Mon, 23 Dec 2013 17:02:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-crypto@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: randconfig build error with next-20131223, in
 arch/x86/crypto/aesni-intel_avx.S
Message-ID: <20131223160238.GA15360@pd.tnic>
References: <CA+r1Zhh5As3QByXMvz0ha5Or2Xtxa3Y=QzuR75O7FwBKTk8XVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+r1Zhh5As3QByXMvz0ha5Or2Xtxa3Y=QzuR75O7FwBKTk8XVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 08:09:18AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> arch/x86/crypto/aesni-intel_avx.S: Assembler messages:
> arch/x86/crypto/aesni-intel_avx.S:1449: Error: bad register name `%r12'
> [...]
> arch/x86/crypto/aesni-intel_avx.S:2807: Error: bad register name `%r12'
> make[2]: *** [arch/x86/crypto/aesni-intel_avx.o] Error 1

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86 3.13.0-rc5 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y

Sounds like this aesni-intel_avx.S thing wasn't meant to be built for
32-bit.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
